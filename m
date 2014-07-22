Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaGVLpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:45:46 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:51366 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaGVLpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:45:45 -0400
MIME-Version: 1.0
In-Reply-To: <1406027485-15657-2-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
	<1406027485-15657-2-git-send-email-lee.jones@linaro.org>
Date: Tue, 22 Jul 2014 17:15:43 +0530
Message-ID: <CAMf-jSn4y40p+tpUNMnCMMmAEQbjXBqbfgPy3zWrTs_b85uvxg@mail.gmail.com>
Subject: Re: [PATCH 01/19] mfd: max77686: Fix 'line over 80 chars' warning
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 4:41 PM, Lee Jones <lee.jones@linaro.org> wrote:
> This is part of an effort to clean-up the MFD subsystem.
>
<snip>
>         max77686->rtc_regmap = devm_regmap_init_i2c(max77686->rtc,
Which kernel are you on? Because 3.16.rc6 does not match with these
lines. Its something like this:
          'max77686->regmap = devm_regmap_init_i2c(i2c,
&max77686_regmap_config);'

Sorry if I am missing something.

> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
