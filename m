Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3JQXET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:04:19 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:36142 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3JQXES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:04:18 -0400
MIME-Version: 1.0
In-Reply-To: <CACz=Wecn4rft6baBq1k9TWDdB41RVOdyWthdowgfZqJozpyX9A@mail.gmail.com>
References: <1381961482-25085-1-git-send-email-geyslan@gmail.com>
	<s5hli1sqv7e.wl%tiwai@suse.de>
	<CAGG-pUQ_5jgrfSEN7_hV982FBtCmdba231gwtqfbxejshLmHhg@mail.gmail.com>
	<s5hzjq8t6pl.wl%tiwai@suse.de>
	<CAGG-pUQAOZ852CamCE+T4zM2Wwc0xKr+WRbGQLEqK=EvC3JCvw@mail.gmail.com>
	<CACz=Wecn4rft6baBq1k9TWDdB41RVOdyWthdowgfZqJozpyX9A@mail.gmail.com>
Date: Thu, 17 Oct 2013 20:04:17 -0300
Message-ID: <CAGG-pUT77AWL8gJ7C5gwucTZOZmzPq3d9gmX=7yfJXyEEo1DdA@mail.gmail.com>
Subject: Re: [Kernel-BR] Re: [PATCH] sound: pci: emu10k1: code refactoring and
 casting removal
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Raphael S Carvalho <raphael.scarv@gmail.com>
Cc: kernel-br <kernel-br@googlegroups.com>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>, Bill Pemberton <wfp5p@virginia.edu>,
        "moderated list:SOUND" <alsa-devel@alsa-project.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/17 Raphael S Carvalho <raphael.scarv@gmail.com>:
>> 2013/10/17 Takashi Iwai <tiwai@suse.de>:
>>>
>>> Geyslan, you don't have to waste too much of your time (and my time
>>> for review) for this kind of so old driver code unless it really fixes
>>> the bugs.  A clean up is good in general, but it can be sometimes
>>> worse than nothing since it also breaks the history, thus makes hard
>>> to follow via "git blame", for example, and of course, there is always
>>> a potential danger of regression.
>>>
>>> So, if it's about clean up, do it only in a systematic way that others
>>> can follow easily, and don't do it too intensively.
>>>
>>>
>>> thanks,
>>>
>>> Takashi
Takashi,

I sent the last version:
[PATCH v3] sound: pci: emu10k1: code refactoring

Regards.

>
> His code refactoring proposal is welcome since the old code sucks from
> several points of view, e.g. maintainability, legibility, etc.
> Yes, of course, it's important to be careful in order not to introduce
> regressions. And yes, he could improve something here and there.
> As long as changes improve the maintainability and legibility of the
> code, there is no reason to refuse them.
>
> --
> Raphael S. Carvalho

Raphael, thank you for reply.

Regards.
