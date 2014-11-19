Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaKSKAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:00:30 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60615 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaKSKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:00:28 -0500
MIME-Version: 1.0
In-Reply-To: <546C67F1.1000005@linaro.org>
References: <1416125020-5715-1-git-send-email-b.galvani@gmail.com>
	<546C67F1.1000005@linaro.org>
Date: Wed, 19 Nov 2014 11:00:27 +0100
X-Google-Sender-Auth: tf9scp5g-ZKcwhO1g8AxtOb6Ask
Message-ID: <CAOQ7t2a6RdEF8wzOFTek72sgvDuag_U1_Q0ihY9hQPpCvxZQ8g@mail.gmail.com>
Subject: Re: [PATCH] clocksource: meson6: Select CLKSRC_MMIO
From: Carlo Caione <carlo@caione.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:50 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 11/16/2014 09:03 AM, Beniamino Galvani wrote:
>>
>> Select CLKSRC_MMIO when the meson6_timer driver is enabled since it
>> depends on clocksource MMIO functions.
>>
>> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
>
>
> patch queued for 3.19
>
> Thanks !

Hi Daniel,
actually I already pulled this fix with the meson/soc changes in
http://www.spinics.net/lists/arm-kernel/msg378895.html
Sorry for the confusion (yeah, probably it should have gone through
your tree, sorry for that).

-- 
Carlo Caione
