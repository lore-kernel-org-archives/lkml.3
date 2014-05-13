Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207AbaEMLAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:00:04 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:63220 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933104AbaEMK77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:59 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Tue, 13 May 2014 11:59:42 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
Message-ID: <20140513105942.GH7239@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	=?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
	David Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>
References: <CAKMK7uG20sF403PJcmWTD=kPF9seV4sXZpp9_hEq3LvV3kK5Hg@mail.gmail.com>
 <CADDKRnB1DCzgjX-q-cgFFW48uT5r5MUcuc5D6chekEET5dFxxA@mail.gmail.com>
 <20140509161438.GH31479@strange.amr.corp.intel.com>
 <20140509170335.GZ18465@intel.com>
 <CADDKRnAiQawK6vi0XO2FDdfGDbcwWQzdeu-rfEU8viJzARO+yQ@mail.gmail.com>
 <CAKMK7uHLSfW0wN-uXMejOcnvaYpZfVSfSh7+NpqAUBCOvbK2eg@mail.gmail.com>
 <CADDKRnCzHQw7_Cr2jpZ7qC50hrdmr0XRaYyMxaOSaqihNGccDA@mail.gmail.com>
 <20140512190300.GF25056@phenom.ffwll.local>
 <CADDKRnAOkdaziCQ_NGkt01hiQqjiAiKza2+QbCuDBuY72LJK=A@mail.gmail.com>
 <CAKMK7uGy3bKdj-B21rCpeF2EPEE4Wi8CxLbDWFBGpLWskoDj3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uGy3bKdj-B21rCpeF2EPEE4Wi8CxLbDWFBGpLWskoDj3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:38:41PM +0200, Daniel Vetter wrote:
> On Tue, May 13, 2014 at 12:29 PM, Jörg Otte <jrg.otte@gmail.com> wrote:
> >>> Branch drm-intel-nightly as of
> >>> ed60c27 drm-intel-nightly: 2014y-05m-09d-21h-51m-45s integration manifest
> >>> looks badly:
> >>>    - KDE splash screen on boot-up is not visible
> >>>    - x-windows don't have title and menu bars
> >>>    - KDE system menu is not visible
> >>>    - moving windows around destroys its content
> >>
> >> Ugh, that's ugly. Nothing else change like e.g. the version of
> >> xfree-video-intel?
> >
> >  (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
> >  (II) Module intel: vendor="X.Org Foundation"
> >  compiled for 1.11.3, module version = 2.17.0
> >  Module class: X.Org Video Driver
> >  ABI class: X.Org Video Driver, version 11.0
> 
> Chris, any ideas? It's an ivybridge apparently.

https://bugs.freedesktop.org/show_bug.cgi?id=78494
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
