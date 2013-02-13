Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab3BMJ6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:58:21 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:23779 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932815Ab3BMJ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:58:05 -0500
Message-ID: <511B63A6.1080208@gaisler.com>
Date: Wed, 13 Feb 2013 10:57:58 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v3 4/5] of: Create function for counting number of phandles
 in a property
References: <1360710401-16757-1-git-send-email-grant.likely@secretlab.ca> <1360710401-16757-5-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1360710401-16757-5-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-13 00:06, Grant Likely wrote:
> This patch creates of_count_phandle_with_args(), a new function for
> counting the number of phandle+argument tuples in a given property. This
> is better than the existing method of parsing each phandle individually
> until parsing fails which is a horribly slow way to do the count.
>
> Tested on ARM using the selftest code.
>
> v3: - Rebased on top of selftest code cleanup patch
> v2: - fix bug where of_parse_phandle_with_args() could behave like _count_.
>      - made of_gpio_named_count() into a static inline regardless of CONFIG_OF_GPIO
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Andreas Larsson <andreas@gaisler.com>

Tested-by: Andreas Larsson <andreas@gaisler.com>

Cheers,
Andreas Larsson

