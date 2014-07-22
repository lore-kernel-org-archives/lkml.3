Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaGVM1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:27:55 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55400 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaGVM1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:27:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140722121306.GB16065@lee--X1>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
	<1406027485-15657-2-git-send-email-lee.jones@linaro.org>
	<CAMf-jSn4y40p+tpUNMnCMMmAEQbjXBqbfgPy3zWrTs_b85uvxg@mail.gmail.com>
	<20140722121306.GB16065@lee--X1>
Date: Tue, 22 Jul 2014 17:57:52 +0530
Message-ID: <CAMf-jSmyzMzucni8-Ego1K+-TvHm5S+HaY5OQKmR1QbjTNrOGQ@mail.gmail.com>
Subject: Re: [PATCH 01/19] mfd: max77686: Fix 'line over 80 chars' warning
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 5:43 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, 22 Jul 2014, pramod gurav wrote:
>
> It's based on the most recent MFD for-mfd-next branch.
>
> You're missing the following patches:
>
>   mfd: max77686: Remove unneeded OOM error message
>   mfd: max77686: Make error checking consistent
>   mfd: max77686: Return correct error when pdata isn't found
>   mfd: max77686: Make platform data over-rule DT
>   mfd: max77686: Don't define dummy function if OF isn't enabled
>   mfd: max77686: Add power management support
>   mfd: max77686: Convert to use regmap_irq
>
ok. Thanks. :)

> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog



-- 
Thanks and Regards
Pramod
