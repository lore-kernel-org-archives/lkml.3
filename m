Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3F1I3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:29:13 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:42671 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3F1I3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:29:10 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUUsDoJHDk0Ug7FRc652CJvmcNdvhT1x44+8LOA2OSU3Hg@mail.gmail.com>
References: <CA+icZUUsDoJHDk0Ug7FRc652CJvmcNdvhT1x44+8LOA2OSU3Hg@mail.gmail.com>
Date: Fri, 28 Jun 2013 18:29:08 +1000
Message-ID: <CAPM=9tySnq0SDJEy0qvhhqjTnsSNTMuYzaMgOoi44SBRhuTF2Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 28 [ call-trace: workqueue | drm
 releated? ]
From: Dave Airlie <airlied@gmail.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> [ CC wq and drm(-intel) folks ]
>

Already know the commit which caused it, mentioned on dri-devel,
waiting for danvet to wake up and look, before I revert it later.

Dave.
