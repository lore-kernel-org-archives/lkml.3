Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaK2WIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 17:08:41 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28472 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaK2WIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 17:08:40 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/6a4OORvzUuExIs1Raflij
Date: Sat, 29 Nov 2014 14:06:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Kevin Hilman <khilman@kernel.org>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [RFC] i2c: omap: TEST: do IP reset during probe.
Message-ID: <20141129220619.GZ2817@atomide.com>
References: <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
 <1417028722-29306-1-git-send-email-al.kochet@gmail.com>
 <7hzjbdd57j.fsf@deeprootsystems.com>
 <20141128221350.GW2817@atomide.com>
 <E4A4FA05-0752-41CB-B86B-84035C6EAF05@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E4A4FA05-0752-41CB-B86B-84035C6EAF05@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Kochetkov <al.kochet@gmail.com> [141128 15:27]:
> Hello, Tony!
> 
> I just want to know, is multimaster i2c feature is interesting for TI SOC,
> so I could send another patches?

Sure and thanks for looking into fixing things.
 
> Or it's better to leave the thing without changes, as current single master version
> well tested and work?

Well once the fixes are in, I don't see any reason to not add
multimaster support.
 
> Also I have a draft version of mixed multimaster/slave version. But it could introduce new bugs.
> Are we ready for that? Thats because IP behavior, sometimes, doesn't correspond to TRMs[4][5].
> It's the one of strange IP I ever seen on TI SOC. And TRM not as detailed as DSP TRMs.

I think we can pretty easily test the i2c support before things get
merged. I guess it should then be possible to loop two i2c controllers
and run automated tests on them :)
 
> Looks, like you haven't seen my response in another thread[1].
> So, duplicate it here.

Sorry I guess I forgot to reply, let me know if I still missed something.

I'll give your two fixes a try on Monday hopefully.

Regards,

Tony
