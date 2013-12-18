Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3LRRZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:25:20 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:52582 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3LRRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:25:18 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: am335x: IIO/ADC fixes if used together with TSC
From: Jonathan Cameron <jic23@kernel.org>
Date: Wed, 18 Dec 2013 17:25:09 +0000
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <d916c9be-2614-41b8-ae92-67bf1a57ed74@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given timing I suspect that by the we have reviewed these will be too late in this cycle so will hit in the merge window plus stable.

Also some of these are cleanups rather than fixes so should normally be separate from fixes and applied after them as they are not 
Stable material.

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>Hi,
>
>this series got a little bigger than expected with a biggy at the end.
>I didn't managed to split the patches across the three subsystems it
>touches due to the changes are required to keep it working and break
>the
>logic.
>Even in 5/5 which does three logical changes I didn't manage to split
>it
>in three patches because the driver would not be functional (sometimes
>it would
>get worse than before). This is all documented in the changelog. 
>Thefore I ask to get this series applied via one tree, the iio tree
>which contains
>or depends on the most changes.
>
>The two bigger issues here are fixed by the last patch incuding
>- time outs on the iio/adc side while TSC&ADC is used together
>- a lockup issue which occurs while TSC&ADC is used together.
>
>Sebastian
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
