Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbaDPUde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:33:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57438 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaDPUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:33:32 -0400
Message-ID: <534EE90A.7070602@infradead.org>
Date: Wed, 16 Apr 2014 13:33:14 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Anton Vorontsov <anton@enomsg.org>
CC: Olof Johansson <olof@lixom.net>, Sachin Kamat <sachin.kamat@linaro.org>,
        ajaykumar.rs@samsung.com, linux-samsung-soc@vger.kernel.org,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] regulator: tps65090: Allow setting the overcurrent
 wait time
References: <1397592876-5741-1-git-send-email-dianders@chromium.org> <1397672724-9063-1-git-send-email-dianders@chromium.org> <1397672724-9063-5-git-send-email-dianders@chromium.org>
In-Reply-To: <1397672724-9063-5-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 11:25 AM, Doug Anderson wrote:
> diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
> index 2e92ef6..ca13a1a 100644
> --- a/drivers/regulator/tps65090-regulator.c
> +++ b/drivers/regulator/tps65090-regulator.c
> @@ -28,15 +28,57 @@

> +/**
> + * tps65090_reg_set_overcurrent_wait - Setup overcurrent wait
> + *
> + * This will set the overcurrent wait time based on what's in the regulator
> + * info.
> + *
> + * @ri:		Overall regulator data
> + * @rdev:	Regulator device
> + * @return 0 if no error, non-zero if there was an error writing the register.

kernel-doc notation here should be:

 * Return: 0 if no error, non-zero if there was an error writing the register.

> + */
> +static int tps65090_reg_set_overcurrent_wait(struct tps65090_regulator *ri,
> +					     struct regulator_dev *rdev)
> +{


-- 
~Randy
