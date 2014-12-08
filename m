Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbaLHPIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:08:40 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:53917 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbaLHPIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:08:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Matthias Klein <matthias.klein@linux.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: manual merge of the bcm2835 tree with the arm-soc tree
Date: Mon, 08 Dec 2014 16:08:14 +0100
Message-ID: <27886656.dlK0fV8eSK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141208134903.GN3951@x1>
References: <20141208120619.68287b54@canb.auug.org.au> <3348703.0b5FTH9Sa3@wuerfel> <20141208134903.GN3951@x1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:OPcg0eILUuJJRSzDAAjUCNPBE6309EU59EvQxvg1MF/NMKM0ZAi
 X78tblV9pUgNBBYFy+r9WHyb/Sj+V/PGqNJfJ8EVOOiC8/hOaCxV2zD6h8jOOEwjjt6wc/T
 py7UMh15dhHvAwQa9Wxr2gBGfwnSi4+7x3FjhjUB4K3JOQxNKubS3XOR0mhP5XBmCgT/BAA
 ZlAHZmh9/A12veSmjbPUQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 13:49:03 Lee Jones wrote:
> On Mon, 08 Dec 2014, Arnd Bergmann wrote:
> 
> > On Monday 08 December 2014 13:00:09 Lee Jones wrote:
> > > On Mon, 08 Dec 2014, Arnd Bergmann wrote:
> > > 
> > > > On Monday 08 December 2014 12:06:19 Stephen Rothwell wrote:
> > > > > Hi Stephen,
> > > > > 
> > > > > Today's linux-next merge of the bcm2835 tree got a conflict in
> > > > > arch/arm/boot/dts/Makefile between commit 302a5ef29d49 ("ARM: BCM5301X:
> > > > > Add DT for Netgear R6300 V2") from the arm-soc tree and commit
> > > > > 6298ed17a404 ("ARM: bcm2835: Add device tree for Raspberry Pi model
> > > > > B+") from the bcm2835 tree.
> > > > > 
> > > > > I fixed it up (the bcm2835 tree patch is also in the arm-soc tree as
> > > > > commit ba2a1d6959ac ("ARM: bcm2835: Add device tree for Raspberry Pi
> > > > > model B+"), so I just used the arm-soc version) and can carry the fix
> > > > > as necessary (no action is required).
> > > > 
> > > > Thanks a lot for the notification!
> > > > 
> > > > Lee, do you know what is going on? Did you accidentally rebase a commit
> > > > that you already sent for inclusion in arm-soc?
> > > 
> > > Nope.  The branch hasn't changed at all.
> > > 
> > > OOI why would a re-base affect anything?  I sent you it in patch form.
> > 
> > Ah, I looked at the wrong branch and didn't see that I applied a patch
> > instead of a pull request. It's all fine then, as long as you never
> > intend to send any pull requests based on top of your current branch.
> > 
> > You can possibly make Stephen's life a tiny bit simpler if you just
> > drop all patches from your for-next branch as soon as we've picked
> > them up into arm-soc.
> 
> That is something I thought about, but I believe we have users of that
> branch.  I guess we could always point them to ARM-SoC, or reset the
> branch to the aforementioned.

How about adding another branch then, which contains everything you
expect to get merged into the next kernel and that you can provide
to your users but that is potentially separate from the one that Stephen
pulls into linux-next?

	ARnd
