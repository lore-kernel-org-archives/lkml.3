Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbaCWV1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 17:27:17 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:51009 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaCWV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 17:27:16 -0400
Date: Sun, 23 Mar 2014 22:27:15 +0100
From: Andreas Mohr <andi@lisas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>, Mikulas Patocka <mpatocka@redhat.com>,
        David Airlie <airlied@linux.ie>, DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in
 mga_driver_irq_uninstall)
Message-ID: <20140323212715.GA22767@rhlx01.hs-esslingen.de>
References: <alpine.LRH.2.02.1402261551010.9913@file01.intranet.prod.int.rdu2.redhat.com>
 <20140322234317.GA10483@rhlx01.hs-esslingen.de>
 <20140323121541.GA20971@rhlx01.hs-esslingen.de>
 <CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 09:39:16AM -0700, Linus Torvalds wrote:
> On Sun, Mar 23, 2014 at 5:15 AM, Andreas Mohr <andi@lisas.de> wrote:
> >
> > which did end up flawless on 3.12.0-rc2+, too
> > (but failed to improve the issue on 3.14.0-rc7+).
> >
> > So, for all intents and purposes, drm infrastructure seems unavoidably
> > (neither dri disable nor libdrm upgrade helps) affected.
> > Does anyone know which change caused that issue?
> > (I'm asking because bisect here would be relatively painful).
> 
> So 3.12-rc2 works. Does 3.13 work? Is this a regression in the current
> 3.14 rc only, or did it happen already in the previous release?

Hmm, given that Mikulas in
https://lkml.org/lkml/2014/2/26/537
offered a diff of linux-3.13.5 files, it truly seems (shock! ack! noo!)
that that indeed may have been a regression at <= 3.13 proper even
(which may pose interesting questions about the level of testing coverage
we still enjoy [not!?] in this hardware area).

Oh well, seems I'll have to prepare/build 3.13 now...

Thanks,

Andreas Mohr
