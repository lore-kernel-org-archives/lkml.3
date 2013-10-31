Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3JaXvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:51:39 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39677 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3JaXvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <5272E920.6030606@iki.fi>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
	<1380659456-3746-2-git-send-email-anssi.hannula@iki.fi>
	<CACna6ryr37WRvKbMFmLEGt_A2zUD46rZOtJMVom+B_xK9WNLuw@mail.gmail.com>
	<07e8973b4665cc23c3f4a77e9c7e2b7c@mail.onse.fi>
	<CACna6ryFtmZHAhmCPEsoxZc5h4mLuM4ajnKGsp=q0jag2f_SYw@mail.gmail.com>
	<5272BCE1.7010700@iki.fi>
	<CACna6rzejyTOF2Fvvw1m2SAob7uU5-hJ+yRVk6HS5pDTz7+JWg@mail.gmail.com>
	<5272E920.6030606@iki.fi>
Date: Fri, 1 Nov 2013 00:51:37 +0100
Message-ID: <CACna6rxuSUA9_1HXnY8yPhQ8BDeEnMvoX6i0WvTtst7UTvcgHA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ALSA: hda - hdmi: Add ATI/AMD multi-channel audio support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        =?UTF-8?Q?Peter_Fr=C3=BChberger?= <fritsch@xbmc.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/1 Anssi Hannula <anssi.hannula@iki.fi>:
> Just to check, is the display mode 720p50 or higher (as per HDMI spec
> 7.3.3)? Though I guess too small mode would cause something else, not
> this...

I'm using 1080p all the time. Do you think that
HDMI_AUDIO_PACKETS_PER_LINE may have anything to do with this issue
(see evergreen_hdmi.c)?


> Also, does DTS-HD/TrueHD work with this receiver (interesting since
> those require 8-channel 192kHz link)?

Both are working for me. I've tested it using 2 movies:
1) English TrueHD.5.1 @ 1417 kbps
2) Audio
Codec................: DTSHD-MA
Bitrate..............: 3718 kbps
kHz/bit..............: 24-bit
Channels.............: 5.1
Language.............: English


> Would be interesting to check if this works in Windows I guess (or maybe
> even just fglrx, though I can't think of a reason it'd make a difference).

Installing fglrx is an option, I can try that. Not a big chance for
Windows here.

-- 
Rafał
