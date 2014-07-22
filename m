Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaGVMNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:13:14 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58448 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaGVMNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:13:12 -0400
Date: Tue, 22 Jul 2014 13:13:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: pramod gurav <pramod.gurav.etc@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 01/19] mfd: max77686: Fix 'line over 80 chars' warning
Message-ID: <20140722121306.GB16065@lee--X1>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
 <1406027485-15657-2-git-send-email-lee.jones@linaro.org>
 <CAMf-jSn4y40p+tpUNMnCMMmAEQbjXBqbfgPy3zWrTs_b85uvxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMf-jSn4y40p+tpUNMnCMMmAEQbjXBqbfgPy3zWrTs_b85uvxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, pramod gurav wrote:

> On Tue, Jul 22, 2014 at 4:41 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > This is part of an effort to clean-up the MFD subsystem.
> >
> <snip>
> >         max77686->rtc_regmap = devm_regmap_init_i2c(max77686->rtc,
> Which kernel are you on? Because 3.16.rc6 does not match with these
> lines. Its something like this:
>           'max77686->regmap = devm_regmap_init_i2c(i2c,
> &max77686_regmap_config);'
> 
> Sorry if I am missing something.

It's based on the most recent MFD for-mfd-next branch.

You're missing the following patches:

  mfd: max77686: Remove unneeded OOM error message
  mfd: max77686: Make error checking consistent
  mfd: max77686: Return correct error when pdata isn't found
  mfd: max77686: Make platform data over-rule DT
  mfd: max77686: Don't define dummy function if OF isn't enabled
  mfd: max77686: Add power management support
  mfd: max77686: Convert to use regmap_irq

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
