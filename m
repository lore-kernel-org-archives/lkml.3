Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3HCUkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 16:40:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53150 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3HCUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 16:40:45 -0400
Date: Sat, 03 Aug 2013 13:40:42 -0700 (PDT)
Message-Id: <20130803.134042.2228681844349448961.davem@davemloft.net>
To: aaro.koskinen@iki.fi
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130617055839.GB3073@blackmetal.musicnaut.iki.fi>
References: <alpine.SOC.1.00.1306162346340.23595@math.ut.ee>
	<20130617053225.GA3073@blackmetal.musicnaut.iki.fi>
	<20130617055839.GB3073@blackmetal.musicnaut.iki.fi>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 03 Aug 2013 13:40:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Mon, 17 Jun 2013 08:58:39 +0300

> On Mon, Jun 17, 2013 at 08:32:25AM +0300, Aaro Koskinen wrote:
>> On Mon, Jun 17, 2013 at 12:06:00AM +0300, Meelis Roos wrote:
>> > Got this in 3.10-rc6 whil testing debian unstable upgrade with aptitude. 
>> > 3.10-rc5 did not exhibit this (nor any other kernel recently tried, 
>> > including most -rc's). Does not seem to be reproducible.
>> 
>> I get this regularly on Ultrasparc during long compilations. It's been
>> there with all recent kernels (probably at least since 3.8). Latest I
>> saw with 3.10-rc5.
> 
> Two examples:

Thanks for the reports, I'm actively looking into this.
