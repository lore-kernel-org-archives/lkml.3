Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaCXIg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:36:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59867 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaCXIgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:36:55 -0400
Date: Mon, 24 Mar 2014 08:36:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: st-pwm: Convert to get_voltage_sel
Message-ID: <20140324083650.GI8541@lee--X1>
References: <1395444158.25974.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395444158.25974.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also remove test for selector in st_pwm_regulator_set_voltage_sel, the checking
> is already done in .list_voltage.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/st-pwm.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Wow! Not even going to give me a chance to fix it myself eh?

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
