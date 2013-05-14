Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3ENT4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:56:06 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:62643 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3ENT4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <s5hd2stq152.wl%tiwai@suse.de>
References: <CALxABCbP9hkNQ=xTEUMWb+6UhmVs2N-5kauYJe7d=j1z_RL+LA@mail.gmail.com>
 <s5h8v3irjeb.wl%tiwai@suse.de> <s5hy5biq3kr.wl%tiwai@suse.de>
 <CALxABCbyALmAKwCC6wNOgQWs8jD2X72aH8_++OW6R7m7C3vgfw@mail.gmail.com>
 <s5hr4haw190.wl%tiwai@suse.de> <s5hd2stq152.wl%tiwai@suse.de>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Tue, 14 May 2013 21:55:43 +0200
Message-ID: <CALxABCaxJkG486g2reFDJD_nKzyaZkJnsRrwaLFNC9eFZBcXTg@mail.gmail.com>
Subject: Re: regression: from 3.8 to 3.9: headphones output no sound on Intel
 HDA, codec VIA VT1802
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 12:58 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> OK, then we know the place to fix now.
>> Try the patch below instead.  Does it fix the problem as well?
>
> The below is the revised patch, fixing not only for VT1802 but other
> VIA codecs, too.  Please let me know if it works.

With this patch headphones work, but Auto-Mute is inverted, as it was before.

Regards,
Alex
