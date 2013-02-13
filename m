Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081Ab3BMOuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:50:40 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:47111 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024Ab3BMOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAHfmSg3-YthwNUTCmbEQox5ihjYHw9TT=WaH_fbjHHyJ+ew7eA@mail.gmail.com>
References: <CAHfmSg2akcYUwDW38g520Fwyr17E5dFDpuUMKejQCfLpQ4pnhQ@mail.gmail.com>
	<CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
	<20121230094008.GA28308@x1.alien8.de>
	<CAHfmSg0O90nC3rnkZHAjO_MNjOoU1v8h-LN+jxx=0U+pz7NasQ@mail.gmail.com>
	<20121231102300.GA1701@x1.alien8.de>
	<3908561D78D1C84285E8C5FCA982C28F1C973871@ORSMSX108.amr.corp.intel.com>
	<CAHfmSg14itHxTUinrmmTq2zoFuQAVwhPCo-Mt7tTLJEiJ4B0Sw@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F1C973F99@ORSMSX108.amr.corp.intel.com>
	<CAHfmSg3-YthwNUTCmbEQox5ihjYHw9TT=WaH_fbjHHyJ+ew7eA@mail.gmail.com>
Date: Wed, 13 Feb 2013 22:50:37 +0800
Message-ID: <CAHfmSg0sxOEvLd9ASHA7uS+W2TiZ-NRR+w8snPu85iYrMFCuVA@mail.gmail.com>
Subject: Re: Fwd: PROBLEM: Random kernel panic & system freeze when watching video
From: Du Jiulun <dujiulun@gmail.com>
To: linux-kernel@vger.kernel.org, Hillf Danton <dhillf@gmail.com>,
        Mike Galbraith <bitbucket@online.de>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel developers, Hillf, Mike, Boris and Tony,

Hello. It's been a long time since I last replied this email, and I
don't know if it's appropriate to reply all of you in one letter.

I've tried out most of the suspects you told me, and here's the results:

-- Panic DON'T happen when the laptop is running on battery. I've
tried over 20 battery cycles (~40 hours) doing video playbacks and the
computer never shut down.
-- Panic DO happen when: (1) I removed the secondary SSD and the tray,
or when (2) bbswitch module isn't functioning (i.e. the nVidia card is
on), or when (3) the laptop runs on AC without battery.
-- I don't know anyone with exactly same model or hardware with me.
But I asked some friends with similar hardware and they don't have
similar problem.
-- I ran memtest86+ for a whole night (over 10 passes) and nothing goes wrong.
-- There is something wrong with my hard drive (one sector redirect
reported by SMART 0x05, failure reported with value 1 in 0xB8, and
another old failure in 0xBE; it's a little old), and sometimes it
halts and panics between fscking rootfs and fscking /home (I don't
know why and don't have the logs), but I did a long test with
Seagate's SeaTool and it passed.
-- The panics happen when using Google Chrome's Flash plugin to play
videos and *audios* and when using mplayer to play videos, but don't
happen when playing local audios (mp3/flac).

I start to think that it's only me that have this problem, and may
never be able to get fixed. But I'll still be a Linux desktop user no
matter what.

Big thanks to all of you and all of the kernel developers for your
help and great job.
