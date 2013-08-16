Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab3HPKeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:34:01 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42410 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3HPKd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:33:57 -0400
Message-ID: <520E0E22.4000403@kernel.org>
Date: Fri, 16 Aug 2013 12:33:54 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and trigger
 support
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com> <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com> <520CBEC6.8010400@kernel.org> <20130816100702.GD26895@linutronix.de>
In-Reply-To: <20130816100702.GD26895@linutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/13 11:07, Sebastian Andrzej Siewior wrote:
> * Jonathan Cameron | 2013-08-15 12:43:02 [+0100]:
> 
>> Hi,
> Hi Jonathan,
> 
>> Whilst the below review is based on what we have here, I tried to apply it
>> to the latest iio.git togreg branch (which for this driver should be
>> much the same as staging-next and hence linux-next).  It's not even
>> close and I can't immediately spot where some of the changes came
>> from.  Have I missed a precursor patch or is this based on an
>> older version of this driver?
> 
> I took the four patches, checkout iio/fixes-togreg and then
> 
> |git am -3 iio.mbox
> |Applying: input: ti_am335x_tsc: correct step mask update after IRQ
> |Applying: input: ti_am335x_tsc: Increase sequencer delay time
> |Applying: input: ti_am335x_tsc: Enable shared IRQ for TSC, add overrun and underflow checks
> |Applying: iio: ti_am335x_adc: Add continuous sampling and trigger support
> 
> It did apply with no trouble here.
> Let me look at your comments…

Ah, fixes-togreg is for this cycle, whereas new stuff like this needs
to go on the togreg branch.  Hence please rebase on the togreg branch
instead.

That would explain it.
