Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab3CFOoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:44:16 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:48140 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab3CFOoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:44:07 -0500
MIME-Version: 1.0
In-Reply-To: <CADuOw60MnsGOb+rd=ANJuJtHmp7nnr+oWV5j3396YHEOrV84Mg@mail.gmail.com>
References: <50BDF345.60804@gmail.com>
	<1354630272.2480.4.camel@rzhang1-mobl4>
	<50BEF830.6020206@gmail.com>
	<50D1CF9D.2090709@infracom.it>
	<CADuOw61+kM6o-zK=7ZTZQSDU8-y-_NcmAaVJFnaSzNBXuqzggg@mail.gmail.com>
	<1361319657.2264.0.camel@rzhang1-mobl4>
	<5124D276.4020802@infracom.it>
	<CADuOw60MnsGOb+rd=ANJuJtHmp7nnr+oWV5j3396YHEOrV84Mg@mail.gmail.com>
Date: Wed, 6 Mar 2013 15:44:04 +0100
Message-ID: <CADuOw61tGLhh-aTH826GRurZvKzgvnwO6Y0W_We8nOD65br5_g@mail.gmail.com>
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume
 at 100%
From: Salvatore Sisinni <s.sisinni@gmail.com>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 6:17 PM, Salvatore Sisinni <s.sisinni@gmail.com> wrote:
>
> On Wed, Feb 20, 2013 at 2:41 PM, Roberto Oppedisano
> <roberto.oppedisano@infracom.it> wrote:
>
> > Il 20/02/2013 01:20, Zhang Rui ha scritto:
>
> >> can you please check if the problem still exists in the -next branch of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
> >
> >
> > I had a merge conflict resolved with a:
> >
> > git rm drivers/thermal/exynos_thermal.c
> >
> > (the file is unused with my config).
> >
> > Anyway now I'm running on your next branch and the problem seems to be gone
> > (I tried a couple of suspend resume cycles).
>
> Sorry, I cannot confirm


Hello,

FedoraForum.org helped me to edit the kernel.spec
so that I could build and install kernel source from the branch but I
keep getting cpu fan speed at full speed after resume on my HP 620
the same thing happens with 3.8.1 provided by Fedora
I tried vanilla 3.9.0-rc1 on Fedora 18 and suspend when the power
button is pressed does not work anymore:
the screen gets blank, standby state cannot be achieved and I could
not find a way to resume the laptop so I had to poweroff

Best regards
S.
