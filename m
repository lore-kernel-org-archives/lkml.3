Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab3HNOMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:12:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41598 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740Ab3HNOMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:12:51 -0400
Date: Wed, 14 Aug 2013 15:12:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] drm/i2c: tda998x: add video and audio input
	configuration
Message-ID: <20130814141236.GA29211@n2100.arm.linux.org.uk>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375741218-10225-6-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375741218-10225-6-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:20:15AM +0200, Sebastian Hesselbarth wrote:
> @@ -0,0 +1,23 @@
> +#ifndef __TDA998X_H__
> +#define __TDA998X_H__
> +
> +enum tda998x_audio_format {
> +	AFMT_I2S,
> +	AFMT_SPDIF,
> +};
> +
> +struct tda998x_encoder_params {
> +	int audio_cfg;
> +	int audio_clk_cfg;
> +	enum tda998x_audio_format audio_format;
> +	int audio_sample_rate;
> +	char audio_frame[6];
> +	int swap_a, mirr_a;
> +	int swap_b, mirr_b;
> +	int swap_c, mirr_c;
> +	int swap_d, mirr_d;
> +	int swap_e, mirr_e;
> +	int swap_f, mirr_f;
> +};

You really should pick my version of this header file from the message
I sent earlier:

	E1UllOe-00058q-Ep@rmk-PC.arm.linux.org.uk
	[PATCH RFC 7/8] drm/i2c: nxp-tda998x: add video and audio input configuration

if you're going to suggest that it's something I produced.
