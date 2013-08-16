Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3HPKHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:07:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:38542 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3HPKHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:07:07 -0400
Date: Fri, 16 Aug 2013 12:07:02 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130816100702.GD26895@linutronix.de>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
 <520CBEC6.8010400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <520CBEC6.8010400@kernel.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jonathan Cameron | 2013-08-15 12:43:02 [+0100]:

>Hi,
Hi Jonathan,

>Whilst the below review is based on what we have here, I tried to apply it
>to the latest iio.git togreg branch (which for this driver should be
>much the same as staging-next and hence linux-next).  It's not even
>close and I can't immediately spot where some of the changes came
>from.  Have I missed a precursor patch or is this based on an
>older version of this driver?

I took the four patches, checkout iio/fixes-togreg and then

|git am -3 iio.mbox
|Applying: input: ti_am335x_tsc: correct step mask update after IRQ
|Applying: input: ti_am335x_tsc: Increase sequencer delay time
|Applying: input: ti_am335x_tsc: Enable shared IRQ for TSC, add overrun and underflow checks
|Applying: iio: ti_am335x_adc: Add continuous sampling and trigger support

It did apply with no trouble here.
Let me look at your comments…

Sebastian
