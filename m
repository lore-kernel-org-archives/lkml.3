Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3HVUOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:14:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52109 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3HVUOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:14:03 -0400
Date: Thu, 22 Aug 2013 13:14:02 -0700 (PDT)
Message-Id: <20130822.131402.362258965058758270.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, eilong@broadcom.com,
        amirv@mellanox.com, erdnetdev@gmail.com, willemb@google.com,
        eliezer@tamir.org.il
Subject: Re: [PATCH RFC net-next] net: epoll support for busy poll
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com>
References: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 22 Aug 2013 13:14:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Wed, 21 Aug 2013 13:39:54 +0300

> +	SK_LL_STATE_MISS_2,	/* data came through napi poll twice in a row */

Please rename this to SK_LL_STATE_MISS_MULTI or something like that.

Thanks.
