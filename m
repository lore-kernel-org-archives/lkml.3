Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaAOCxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:53:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54597 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaAOCxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:53:21 -0500
Date: Tue, 14 Jan 2014 18:53:19 -0800 (PST)
Message-Id: <20140114.185319.701097353751396242.davem@davemloft.net>
To: ying.xue@windriver.com
Cc: vfalico@redhat.com, john.r.fastabend@intel.com, stephen@networkplumber.org,
        antonio@meshcoding.com, dmitry.tarnyagin@lockless.no,
        socketcan@hartkopp.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/10] use appropriate APIs to get
 interfaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389752625-23189-1-git-send-email-ying.xue@windriver.com>
References: <1389752625-23189-1-git-send-email-ying.xue@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Xue <ying.xue@windriver.com>
Date: Wed, 15 Jan 2014 10:23:35 +0800

> Under rtnl_lock protection, we should use __dev_get_name/index()
> rather than dev_get_name()/index() to find interface handlers
> because the former interfaces can help us avoid to change interface
> reference counter.
> 
> v2 changes:
>  - Change return value of nl80211_set_wiphy() to 0 in patch #10
>    by johannes's suggestion.
>  - Add 'Acked-by' into several patches which were acknowledged by
>    corresponding maintainers.

This looks fine, series applied, thanks.
