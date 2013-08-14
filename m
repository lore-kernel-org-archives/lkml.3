Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab3HNOes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:34:48 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53574 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab3HNOer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:34:47 -0400
Message-ID: <520B9582.7070503@gmail.com>
Date: Wed, 14 Aug 2013 16:34:42 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] drm/i2c: tda998x: add video and audio input configuration
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375741218-10225-6-git-send-email-sebastian.hesselbarth@gmail.com> <20130814141236.GA29211@n2100.arm.linux.org.uk>
In-Reply-To: <20130814141236.GA29211@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/13 16:12, Russell King - ARM Linux wrote:
> On Tue, Aug 06, 2013 at 12:20:15AM +0200, Sebastian Hesselbarth wrote:
>> @@ -0,0 +1,23 @@
>> +#ifndef __TDA998X_H__
>> +#define __TDA998X_H__
>> +
>> +enum tda998x_audio_format {
>> +	AFMT_I2S,
>> +	AFMT_SPDIF,
>> +};
>> +
>> +struct tda998x_encoder_params {
>> +	int audio_cfg;
>> +	int audio_clk_cfg;
>> +	enum tda998x_audio_format audio_format;
>> +	int audio_sample_rate;
>> +	char audio_frame[6];
>> +	int swap_a, mirr_a;
>> +	int swap_b, mirr_b;
>> +	int swap_c, mirr_c;
>> +	int swap_d, mirr_d;
>> +	int swap_e, mirr_e;
>> +	int swap_f, mirr_f;
>> +};
>
> You really should pick my version of this header file from the message
> I sent earlier:
>
> 	E1UllOe-00058q-Ep@rmk-PC.arm.linux.org.uk
> 	[PATCH RFC 7/8] drm/i2c: nxp-tda998x: add video and audio input configuration
>
> if you're going to suggest that it's something I produced.
>

Right, that one above must have been the one I made up from the
one RFC you forgot to add it. I must have messed it up and will
take yours, of course.

Sebastian
