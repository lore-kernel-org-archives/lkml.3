Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab3BSSRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:17:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34402 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab3BSSRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:17:41 -0500
Date: Tue, 19 Feb 2013 13:17:39 -0500 (EST)
Message-Id: <20130219.131739.1337370562046840058.davem@davemloft.net>
To: mroos@ut.ee
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: THP bug and crash on sparc64 3.8
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1302191405140.10147@math.ut.ee>
References: <alpine.SOC.1.00.1302191350280.10147@math.ut.ee>
	<alpine.SOC.1.00.1302191405140.10147@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Feb 2013 10:17:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@ut.ee>
Date: Tue, 19 Feb 2013 14:05:42 +0200 (EET)

> 	
> (Resent to correct cparclinux address)

Thanks for the report, I'll look into this.
