Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaCHXiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:38:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55063 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaCHXiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:38:12 -0500
Date: Sat, 08 Mar 2014 18:38:07 -0500 (EST)
Message-Id: <20140308.183807.1351815817743999901.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH V2 1/6] Drivers: net: hyperv: Enable scatter gather I/O
From: David Miller <davem@davemloft.net>
In-Reply-To: <c72c0d17b4bd405cb218ab09b1c2e77e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <fd6bb08bd9a447aa9c0da3b584ea9bb8@BY2PR03MB299.namprd03.prod.outlook.com>
	<20140308.013658.918013334851017662.davem@davemloft.net>
	<c72c0d17b4bd405cb218ab09b1c2e77e@BY2PR03MB299.namprd03.prod.outlook.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Mar 2014 15:38:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KY Srinivasan <kys@microsoft.com>
Date: Sat, 8 Mar 2014 10:27:54 +0000

> "len" would have gotten decremented prior to the check and in the
> case we are talking about, "len" would be zero and so j would not
> get incremented.

You are correct, this is the part of the logic in this case which I
missed.

Thanks.
