Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3EaKb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:31:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43799 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab3EaKbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <s5h1u8p7pxi.wl%tiwai@suse.de>
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
 <s5h1u8p7pxi.wl%tiwai@suse.de>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Fri, 31 May 2013 12:31:19 +0200
Message-ID: <CALxABCbBYRJDsXMw0Y0BLs+RuXNMa_RMOAF5i4rmWDaYPa2H0Q@mail.gmail.com>
Subject: Re: regression: from 3.8 to 3.9: headphones output no sound on Intel
 HDA, codec VIA VT1802
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 5:42 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 24 May 2013 23:32:14 +0200, Alex Riesen wrote:
>> I'm sorry to say that I will not be able to test it in the next
>> 8 or so days: I'll be traveling and without this particular laptop
>> with me. I hope someone with similar model (Sytem76 Lemur lemu4, i7)
>> can provide some testing in the meantime. Otherwise, I'll test
>> it as soon as I get back.
>
> Don't worry, the bug is more difficult than I thought :)

I was afraid you will say that sooner or later :)

> When you back, could you try the following and give the outputs?
> ...
> So, you'll get 4 alsa-info.sh outputs (step 3, 6, 7 and 8), and 4
> trace logs (step 5, 6 and 7).

Done. That's a lot of data, so please download it from here:

  http://familie-riesen.de/~raa/public/test/no-cached-write-test.tar.bz2

The system boot is in linuxrc-safemode, and the test itself in test.sh.
The logs and transcript in report/.

Regards,
Alex
