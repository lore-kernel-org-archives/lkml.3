Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3EZOWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 10:22:15 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48051 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752923Ab3EZOWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 10:22:06 -0400
Date: Sun, 26 May 2013 16:22:01 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lubomir Rintel <lkundrak@v3.sk>, linux-kernel@vger.kernel.org,
        Dom Cobley <popcornmix@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v4] watchdog: Add Broadcom BCM2835 watchdog timer driver
Message-ID: <20130526142200.GA7603@spo001.leaseweb.com>
References: <1364320200-23569-1-git-send-email-lkundrak@v3.sk> <1364402424-19503-1-git-send-email-lkundrak@v3.sk> <5153B24D.1010408@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5153B24D.1010408@wwwdotorg.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lubomir,

> On 03/27/2013 10:40 AM, Lubomir Rintel wrote:
> > This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> > used in Raspberry Pi and Roku 2 devices.
> > 
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > Signed-off-by: Dom Cobley <popcornmix@gmail.com>
> 
> Those two s-o-b lines should be swapped, since if Dom did sign off on
> any part of this patch, he did it before you did.
> 
> That said...
> 
> I wonder if it's actually appropriate to include Dom's s-o-b here, since
> I don't think he really wrote this patch itself. I think you mentioned
> that you hadn't use much of the downstream driver except for some defines?
> 
> To be clear, I mentioned the existence of the S-o-b line downstream
> simply to demonstrate that the commits you were getting information from
> had correctly followed the process described in
> Documentation/SubmittingPatches, and so it was OK to use that
> information while creating a GPL'd driver.
> 
> So there are a couple of ways that this patch could have been created:
> 
> 1) You took the downstream commit itself, cherry-picked it into the
> upstream kernel, modified it to suit upstream, and then submitted that.
> The modifications might be extensive, such as renaming the file,
> removing parts of the code that the upstream watchdog core now handles,
> adding some new features, fixing bugs, cleanup, etc.; whatever is needed
> to upstream the patch.
> 
> In this case, I believe it would be appropriate to maintain any S-o-b
> lines from the original downstream commit, and add yours. But, I believe
> you should also (a) maintain the git author field from the original
> downstream commit (b) include a list of the changes you made to the
> patch in the commit description, so you can be blamed for them rather
> than the original author:-)
> 
> 2) You read the downstream commit for information, but created a
> completely new driver for the upstream kernel, using the downstream
> driver just as a reference. In this case, I believe it's fine for the
> git author field to be you, and for the only s-o-b line present to be
> yours, since you really did write the patch from scratch. However, you
> should credit the downstream work in the (c) header and/or commit
> description.
> 
> This current patch sees to be a slight hybrid of both approaches (you're
> listed as the git author, but have included Dom's s-o-b line on a patch
> I don't think he created, and wasn't directly derived from one he created).
> 
> I'm not sure if I'm being too picky. I guess I'll leave it up to Wim Van
> Sebroeck, since he's the watchdog maintainer and would be the person who
> applies this patch.

Can you create a patch v5 with yourselve as author and add the necessary (c)
and references in it so that I can do the final review? (That is if situation
2 is indeed the case. If however it is situation 1 then we should get the
original code and have that as a patch and then add a second patch with your
modifications.).

Kind regards,
Wim.

