Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaLBOqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:46:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39145 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaLBOqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:46:36 -0500
Date: Tue, 2 Dec 2014 15:46:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression: suspend to ram completely broken since at least
 3.13-rc5, works with 3.12.
Message-ID: <20141202144615.GA3178@xo-6d-61-c0.localdomain>
References: <54624E40.30802@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54624E40.30802@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> with kernel 3.12.X with X tested up to .23 suspend to ram works
> flawlessly. My machine suspends quickly and wakes up reliably, giving me
> uptimes measured in weeks.
> 
> Every kernel I tried between 3.13.0-rc5 and 3.16.7 on the other hand
> shows this behaviour:
> 
> IF suspend works it takes ages. Video blanks quickly, harddisks are
> turned off, then it is stuck for a long time (more minute than tens of
> seconds), and at some point suspends.
> 
> Afterwards there is a 50% chance it will wake up. In that case: nothing
> in dmesg.
> If it does not wake up on pressing any button, I have to press power
> button for a nice cold boot.
> 
> Even if it does suspend and resume successfully, it will NOT suspend the
> next time. Never.
> 
> The much more likely failure mode looks like this:
> It will blank video and turn of harddisks and then nothing happens. usb
> dead, ps2 keyboard dead, no harddisk activity, fans are spinning,
> mainboard is powered - and nothing happens. I can turn off or hit reset
> button.
> 
> Of course, after a reboot nothing will show up in the logs.
> 
> So this is a severe regression. Box worked, it stopped working.

Any chance to do a bisect? Any chance to try with minimum drivers?

								Pavel
