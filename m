Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3IYPjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:39:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35988 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3IYPjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:39:46 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-a2-524303c1c0a7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: balbi@ti.com
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: Fix style in s3c-hsotg.c
Date: Wed, 25 Sep 2013 17:39:39 +0200
Message-id: <2758936.kqHJ9YzqCC@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20130918141106.GH21559@radagast>
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
 <20130918092027.GA8325@amd.pavel.ucw.cz> <20130918141106.GH21559@radagast>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQd2DzM5BBhd3sFscvF9vcXnXHDaL
	RctamS3unjrK5sDicfzGdiaPFau/s3t83iQXwBzFZZOSmpNZllqkb5fAlbHl3SLmgn6xirvb
	eRoYPwp0MXJySAiYSOxZcocZwhaTuHBvPVsXIxeHkMB0Rol7DzawgCSEBFqYJI59ZQex2QSs
	JCa2r2IEsUUEBCTWv7gEFmcWyJD4++gv2CBhAVWJm6uOgcVZgOxDb66D2bwCmhJve4+CzRQV
	8JT4NGkpWD2ngJ7E8+XfmSAWNzFKdH5YAdUgKPFj8j0WiAXyEvv2T2WFsHUk9rdOY5vAKDAL
	SdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcsM+kdzCuarA4xCjAwajE
	wytw1DFIiDWxrLgy9xCjBAezkgjvWSbnICHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE
	0hNLUrNTUwtSi2CyTBycUg2Mxm+nHT8uJ/InRtQozf7rLpZ5GcrTvh299dJwbmVsT++7W2/2
	HHi0/vej5N7yoCxtOdEbAkeuya3c6hTI4L74t/3Ew0bb2feKcniZXVGUS10mpMF+8e71OceW
	Fs/bbzzr7/VNJdtfKu2WjE0IOLbj9pTpOtOVj6zedPYx0515W8xadZv/nny6QUyJpTgj0VCL
	uag4EQCkgCJCVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, September 18, 2013 09:11:06 AM Felipe Balbi wrote:
> Hi,
> 
> On Wed, Sep 18, 2013 at 11:20:27AM +0200, Pavel Machek wrote:
> > On Tue 2013-09-17 20:45:39, Felipe Balbi wrote:
> > > On Wed, Sep 18, 2013 at 12:04:27AM +0200, Pavel Machek wrote:
> > > > On Tue 2013-09-17 10:42:30, Felipe Balbi wrote:
> > > > > Hi,
> > > > > 
> > > > > On Mon, Sep 02, 2013 at 03:58:32PM +0200, Pavel Machek wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > checkpatch.pl has some valid complaints about style in s3c-hsotg.c :
> > > > > > macro with if should be really enclosed in do {} while, and puts is
> > > > > > going to be slightly faster.
> > > > > > 
> > > > > > Here's suggested patch. I don't have the hardware, so it is completely
> > > > > > untested.
> > > > > > 
> > > > > > Signed-off-by: Pavel Machek, <pavel@denx.de>
> > > > > 
> > > > > this is not how you send a patch, please read
> > > > > Documentation/SubmittingPatches
> > > > 
> > > > Have you considered possibility that this is how you nudge maintainer
> > > > into fix their coding style?
> > > 
> > > cute...
> > > 
> > > Seriously though, read that file, you're commit log has garbage in it
> > > which shouldn't go to git history.
> > 
> > Run git log on SubmittingPatches.
> > 
> > Then, instead of telling me what to read, run checkpatch on your
> > files. You can either fix them yourself, or use my patch as a
> > basis. Note there's missing } or something, so it probably will not
> > compile, see the other mail. So you actually will have to modify that
> > patch. Stripping "Hi!" from it should not be that hard, neither should
> > be stripping note that patch is untested when you actually test
> > it. And as you are the maintainer, it is your job.
> 
> you misunderstand the work of maintainers. Our work is not to fix you
> crappy patches. If we start allowing crappy patches, we'd be fixing your
> nonsense forever and linux wouldn't move.

Pavel, Felipe's remark was valid..

> > No, I'll not polish patch for hardware I don't have and have little
> > interest in.  wanted to help you, but according to your first reply,
> > you do not really want help.
> 
> that's your call. Now how about you stop being such a baby and go fix
> your mistakes to start with ? Just because I'm the maintainer of the
> gadget framework, doesn't mean I'm the maintainer of s3c-hsotc.c file.
> Maintainer != author too, btw.
> 
> Anyway, I got much better stuff to do than babysitting grown ups.

..even if it could have been communicated in a gentler way.

Anyway s3c-hsotg.c is a driver for our hardware so I'm going to pick this
patch up, polish it and then re-submit it later. Thanks.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

