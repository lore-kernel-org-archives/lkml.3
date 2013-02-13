Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab3BMKAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:00:21 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:24441 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932643Ab3BMKAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:00:19 -0500
Message-ID: <511B642A.9000004@gaisler.com>
Date: Wed, 13 Feb 2013 11:00:10 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v3 5/5] gpio: Make of_count_named_gpios() use new of_count_phandle_with_args()
References: <1360710401-16757-1-git-send-email-grant.likely@secretlab.ca> <1360710401-16757-6-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1360710401-16757-6-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-13 00:06, Grant Likely wrote:
> This patch replaces the horribly coded of_count_named_gpios() with a
> call to of_count_phandle_with_args() which is far more efficient. This
> also changes the return value of of_gpio_count() & of_gpio_named_count()
> from 'unsigned int' to 'int' so that it can return an error code. All
> the users of that function are fixed up to correctly handle a negative
> return value.
>
> v2: Split GPIO portion into a separate patch
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Andreas Larsson <andreas@gaisler.com>

For gpiolib-of.c, of_gpio.h and spi.c:
Tested-by: Andreas Larsson <andreas@gaisler.com>

Cheers,
Andreas Larsson

