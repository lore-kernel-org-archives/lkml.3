Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3EaPcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:32:46 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39785 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab3EaPch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:32:37 -0400
MIME-Version: 1.0
In-Reply-To: <s5hehcn2tc3.wl%tiwai@suse.de>
References: <CALxABCbP9hkNQ=xTEUMWb+6UhmVs2N-5kauYJe7d=j1z_RL+LA@mail.gmail.com>
 <s5h8v3irjeb.wl%tiwai@suse.de> <s5hy5biq3kr.wl%tiwai@suse.de>
 <CALxABCbyALmAKwCC6wNOgQWs8jD2X72aH8_++OW6R7m7C3vgfw@mail.gmail.com>
 <s5hr4haw190.wl%tiwai@suse.de> <s5hd2stq152.wl%tiwai@suse.de>
 <CALxABCaxJkG486g2reFDJD_nKzyaZkJnsRrwaLFNC9eFZBcXTg@mail.gmail.com>
 <s5ha9nwx1j3.wl%tiwai@suse.de> <CALxABCZMyqh5SSo=RpQCJNUR_p9yrG5x9DimFpzvgkCFLr4eug@mail.gmail.com>
 <s5h1u97jik9.wl%tiwai@suse.de> <CALxABCa27gVVJGWM-crvFOPmJXdZ0FEBc3=dPZ0pG+AhDB78cA@mail.gmail.com>
 <s5hk3myuoq6.wl%tiwai@suse.de> <CALxABCZHwKPDKPsjWJmK=-QzcC3fs2bKqHU0SCUmdH7OqGDNdA@mail.gmail.com>
 <s5h1u8wtsk9.wl%tiwai@suse.de> <CALxABCZdm=qd1E63NeabcqmD0csnL1FcuUBCFTwa1yDOVRVXyg@mail.gmail.com>
 <s5h1u8w8f82.wl%tiwai@suse.de> <CALxABCbJ-4_UPNX5qNAOy-PdQ+tp+vVBDE535nLyfjgzDjjebQ@mail.gmail.com>
 <s5h1u8p7pxi.wl%tiwai@suse.de> <CALxABCbBYRJDsXMw0Y0BLs+RuXNMa_RMOAF5i4rmWDaYPa2H0Q@mail.gmail.com>
 <s5hehcn2tc3.wl%tiwai@suse.de>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Fri, 31 May 2013 17:32:16 +0200
Message-ID: <CALxABCaQ_drc+jKP4wZ5S_5wZVcE7rVXW_LZdVJ8tqZUai-=UQ@mail.gmail.com>
Subject: Re: regression: from 3.8 to 3.9: headphones output no sound on Intel
 HDA, codec VIA VT1802
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 3:05 PM, Takashi Iwai <tiwai@suse.de> wrote:
> Below is a series of patches.  For simplicity, I just attach them, not
> inlining to the mail.  They should be applicable cleanly to 3.9.4 as
> well.  Let me know if this works.  If this still doesn't work, I need
> to rewrite the patch to correct the pin-ctl / EAPD of the headphone
> pin after changing the speaker pin.

Still does not work. The results are for 3.9.4 + patches:

  http://familie-riesen.de/~raa/public/test/dpc-automute-vol-pinctl.tar.bz2

I tried patched 3.9.2, with the same result.
