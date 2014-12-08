Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaLHQvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:51:37 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:42567 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaLHQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:51:34 -0500
Date: Mon, 8 Dec 2014 16:51:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>,
        Matthias Klein <matthias.klein@linux.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: manual merge of the bcm2835 tree with the arm-soc
 tree
Message-ID: <20141208165127.GP3951@x1>
References: <20141208120619.68287b54@canb.auug.org.au>
 <2406890.FlzRjyvuXd@wuerfel>
 <20141208130009.GL3951@x1>
 <3348703.0b5FTH9Sa3@wuerfel>
 <20141208134903.GN3951@x1>
 <5485CD02.7010903@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5485CD02.7010903@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2014, Stephen Warren wrote:
> On 12/08/2014 06:49 AM, Lee Jones wrote:
> >On Mon, 08 Dec 2014, Arnd Bergmann wrote:
> >
> >>On Monday 08 December 2014 13:00:09 Lee Jones wrote:
> >>>On Mon, 08 Dec 2014, Arnd Bergmann wrote:
> >>>
> >>>>On Monday 08 December 2014 12:06:19 Stephen Rothwell wrote:
> >>>>>Hi Stephen,
> >>>>>
> >>>>>Today's linux-next merge of the bcm2835 tree got a conflict in
> >>>>>arch/arm/boot/dts/Makefile between commit 302a5ef29d49 ("ARM: BCM5301X:
> >>>>>Add DT for Netgear R6300 V2") from the arm-soc tree and commit
> >>>>>6298ed17a404 ("ARM: bcm2835: Add device tree for Raspberry Pi model
> >>>>>B+") from the bcm2835 tree.
> >>>>>
> >>>>>I fixed it up (the bcm2835 tree patch is also in the arm-soc tree as
> >>>>>commit ba2a1d6959ac ("ARM: bcm2835: Add device tree for Raspberry Pi
> >>>>>model B+"), so I just used the arm-soc version) and can carry the fix
> >>>>>as necessary (no action is required).
> >>>>
> >>>>Thanks a lot for the notification!
> >>>>
> >>>>Lee, do you know what is going on? Did you accidentally rebase a commit
> >>>>that you already sent for inclusion in arm-soc?
> >>>
> >>>Nope.  The branch hasn't changed at all.
> >>>
> >>>OOI why would a re-base affect anything?  I sent you it in patch form.
> >>
> >>Ah, I looked at the wrong branch and didn't see that I applied a patch
> >>instead of a pull request. It's all fine then, as long as you never
> >>intend to send any pull requests based on top of your current branch.
> >>
> >>You can possibly make Stephen's life a tiny bit simpler if you just
> >>drop all patches from your for-next branch as soon as we've picked
> >>them up into arm-soc.
> >
> >That is something I thought about, but I believe we have users of that
> >branch.  I guess we could always point them to ARM-SoC, or reset the
> >branch to the aforementioned.
> 
> The primary purpose of the kernel.org linux-rpi.git repo is for
> staging patches into arm-soc/linux-next. As such, just like any
> other similar repo, users should expect at least the for-xxx (e.g.
> for-next) branches to get reset as kernel versions tick over, in
> order to contain the content for the next kernel. Anyone using those
> branches for anything else (e.g. local development) simply has to be
> prepared to do a rebase themselves when that happens.

I agree with this.

> Equally, and patches that get sent to arm-soc should probably never
> be applied to linux-rpi.git; anything that gets applied to
> linux-rpi.git should get sent to arm-soc as a pull request. That
> avoids duplicate commits.

I'm okay to follow this rule if my perception of the tree is changed.
The current view is that this repo can be used by engineers/hobbyists
as a single resource to pick up RPi patches which are yet to complete
their full transition into Mainline.

Arnd and I had a discussion where I flagged my concerns about these
kinds of conflicts.  The outcome was that as long as the patches were
simple enough, then no conflict should arise.  Unfortunately this
turned out not to be quite true.

So I'm happy with whatever.  Stephen, the repo is your concept.  I'll
play it however you want me to play it.  As the merge-window is now
open I'm going to eradicate rpi/for-next in any case.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
