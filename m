Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3EXVcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 17:32:36 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63003 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3EXVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 17:32:35 -0400
MIME-Version: 1.0
In-Reply-To: <s5h1u8w8f82.wl%tiwai@suse.de>
References: <CALxABCbP9hkNQ=xTEUMWb+6UhmVs2N-5kauYJe7d=j1z_RL+LA@mail.gmail.com>
 <s5h8v3irjeb.wl%tiwai@suse.de> <s5hy5biq3kr.wl%tiwai@suse.de>
 <CALxABCbyALmAKwCC6wNOgQWs8jD2X72aH8_++OW6R7m7C3vgfw@mail.gmail.com>
 <s5hr4haw190.wl%tiwai@suse.de> <s5hd2stq152.wl%tiwai@suse.de>
 <CALxABCaxJkG486g2reFDJD_nKzyaZkJnsRrwaLFNC9eFZBcXTg@mail.gmail.com>
 <s5ha9nwx1j3.wl%tiwai@suse.de> <CALxABCZMyqh5SSo=RpQCJNUR_p9yrG5x9DimFpzvgkCFLr4eug@mail.gmail.com>
 <s5h1u97jik9.wl%tiwai@suse.de> <CALxABCa27gVVJGWM-crvFOPmJXdZ0FEBc3=dPZ0pG+AhDB78cA@mail.gmail.com>
 <s5hk3myuoq6.wl%tiwai@suse.de> <CALxABCZHwKPDKPsjWJmK=-QzcC3fs2bKqHU0SCUmdH7OqGDNdA@mail.gmail.com>
 <s5h1u8wtsk9.wl%tiwai@suse.de> <CALxABCZdm=qd1E63NeabcqmD0csnL1FcuUBCFTwa1yDOVRVXyg@mail.gmail.com>
 <s5h1u8w8f82.wl%tiwai@suse.de>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Fri, 24 May 2013 23:32:14 +0200
Message-ID: <CALxABCbJ-4_UPNX5qNAOy-PdQ+tp+vVBDE535nLyfjgzDjjebQ@mail.gmail.com>
Subject: Re: regression: from 3.8 to 3.9: headphones output no sound on Intel
 HDA, codec VIA VT1802
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0112cf648822f504dd7d8908
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0112cf648822f504dd7d8908
Content-Type: text/plain; charset=UTF-8

On Fri, May 24, 2013 at 7:22 PM, Takashi Iwai <tiwai@suse.de> wrote:
>
> Well, I assumed that the EAPD off triggers the pin widget off by the
> hardware, too.  But it seems wrong.  By some reason, the hardware
> clears the pin automatically.  Hmm.
>
> Could you try to trace the verbs while plugging the headphone?

Attached, it's ~70k, so compressed again.

>> I did, it does not work. Transcript and alsa-info before and after
>> hda-verb attached.
>
> OK, I'll cook up the new patch later.

I'm sorry to say that I will not be able to test it in the next
8 or so days: I'll be traveling and without this particular laptop
with me. I hope someone with similar model (Sytem76 Lemur lemu4, i7)
can provide some testing in the meantime. Otherwise, I'll test
it as soon as I get back.

--089e0112cf648822f504dd7d8908
Content-Type: application/x-gzip; name="trace.log.gz"
Content-Disposition: attachment; filename="trace.log.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hh3vqyp70

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
R6C5vzqS5y23XMwMohgx9z9r35FmwjMBAA==
--089e0112cf648822f504dd7d8908--
