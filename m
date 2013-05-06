Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3EFMrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:47:20 -0400
Received: from mout.gmx.net ([212.227.17.22]:56181 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3EFMrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:47:19 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1+UYdli+C2UoVd4OlHiF4o6+VeSGvnN05L349EVuH
	uk7cB7b1MNI5w+
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: pageexec@freemail.hu
Cc: Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
        airlied@linux.ie, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] [TRIVIAL] Fix declaration of intel_gmbus_{is_forced_bit/is_port_falid} in i915 driver.
Date: Mon, 06 May 2013 14:46:18 +0200
Message-ID: <4246338.ENCyMUo2HP@aragorn.auenland.lan>
User-Agent: KMail/4.10.2 (Linux/3.7.10-1.1-desktop; KDE/4.10.2; x86_64; ; )
In-Reply-To: <5184CD16.8569.184037FF@pageexec.freemail.hu>
References: <1367572662-18400-1-git-send-email-dl9pf@gmx.de> <87k3ngtgme.fsf@intel.com> <5184CD16.8569.184037FF@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so let me resend a version with "static inline" .

Best,
JS


On Saturday 04 May 2013 10:55:50 PaX Team wrote:
> On 3 May 2013 at 15:03, Jani Nikula wrote:
> > >> This fixes a compilation issue with clang. An initial version of this
> > >> patch
> > >> was developed by PaX Team <pageexec at freemail.hu>.
> > >> This is respin of this patch.
> > >> 
> > >> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> > >> CC: pageexec@freemail.hu
> > >> CC: daniel.vetter@ffwll.ch
> > >> CC: airlied@linux.ie
> > >> CC: intel-gfx@lists.freedesktop.org
> > >> CC: dri-devel@lists.freedesktop.org
> > >> CC: linux-kernel@vger.kernel.org
> > > 
> > > Picked up for -fixes, thanks for the patch.
> > 
> > Please drop it.
> > 
> > The patch removes the inline keyword, creating dozens of copies of the
> 
> > functions, and consequently loads of warnings:
> in my original patch they were both static inline, not sure where the
> inline got lost...
-- 

Dipl.-Ing.
Jan-Simon Möller

jansimon.moeller@gmx.de
