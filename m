Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3EGVNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:13:55 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:61860 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3EGVNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <5188BEF7.7090505@vodafone.de>
References: <CAOULuOb79h99RiyYpMGLzzM2QeawYfG8CfrvNtk4WtJJxRn87g@mail.gmail.com>
	<1367910123.12136.7.camel@thor.local>
	<5188BEF7.7090505@vodafone.de>
Date: Tue, 7 May 2013 17:13:52 -0400
Message-ID: <CAOULuObffavZs9+p-C_C5Y6y=6aJhnYVf_d0nXWXb9Zt2A7rBw@mail.gmail.com>
Subject: Re: [PATCH] radeon: Allow disabling UVD
From: Parag Warudkar <parag.lkml@gmail.com>
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
Cc: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 4:44 AM, Christian König <deathsimple@vodafone.de> wrote:

>
> The patch shouldn't be necessary because just removing the firmware should
> have pretty much the same effect.

Soon distros will ship the UVD firmware by default and then users will
need to manually remove it and then do the same with every update.
Besides, I just discovered that when UVD is enabled suspend resume
breaks  - tried 3 times with SUMO_uvd loaded - machine suspends but
resumes instantly.
Without SUMO_uvd.bin - suspends fine and only wakes up when I want it to.

> The only case where we indeed seems to have a problem are Macs with
> integrated cards, and we can always just blacklist those if the problem
> doesn't seems to be solvable.

I happen to have the problematic card in my iMac - I'd be glad to
provide any info or try any patches. Just let me know.
For now I will remove the firmware - I reboot /suspend-resume often
and it is a bit annoying to have to go through those mdelays only to
fail.

Thanks,
Parag
