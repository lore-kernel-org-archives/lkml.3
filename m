Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbaEMLmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:42:12 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58714 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaEMLmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:42:10 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140513105942.GH7239@nuc-i3427.alporthouse.com>
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
	<20140513105942.GH7239@nuc-i3427.alporthouse.com>
Date: Tue, 13 May 2014 13:42:09 +0200
Message-ID: <CAKMK7uGkm2pfN2N236-2YqpTjfKFCu7hTgU0-jM-iMNZH17Opw@mail.gmail.com>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:59 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, May 13, 2014 at 12:38:41PM +0200, Daniel Vetter wrote:
>> On Tue, May 13, 2014 at 12:29 PM, Jörg Otte <jrg.otte@gmail.com> wrote:
>> >>> Branch drm-intel-nightly as of
>> >>> ed60c27 drm-intel-nightly: 2014y-05m-09d-21h-51m-45s integration manifest
>> >>> looks badly:
>> >>>    - KDE splash screen on boot-up is not visible
>> >>>    - x-windows don't have title and menu bars
>> >>>    - KDE system menu is not visible
>> >>>    - moving windows around destroys its content
>> >>
>> >> Ugh, that's ugly. Nothing else change like e.g. the version of
>> >> xfree-video-intel?
>> >
>> >  (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
>> >  (II) Module intel: vendor="X.Org Foundation"
>> >  compiled for 1.11.3, module version = 2.17.0
>> >  Module class: X.Org Video Driver
>> >  ABI class: X.Org Video Driver, version 11.0
>>
>> Chris, any ideas? It's an ivybridge apparently.
>
> https://bugs.freedesktop.org/show_bug.cgi?id=78494

Oops. Patch to fix this regression submitted.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
