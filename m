Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaFKAah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:30:37 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:56143 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFKAaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:30:35 -0400
Message-ID: <5397A319.8030209@gmail.com>
Date: Wed, 11 Jun 2014 02:30:17 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org
CC: linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        mturquette@linaro.org
Subject: Re: [RESEND PATCH v2] clk: exynos4: Add PPMU IP block source clocks.
References: <1402446171-3560-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1402446171-3560-1-git-send-email-jonghwa3.lee@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwa,

On 11.06.2014 02:22, Jonghwa Lee wrote:
> Exynos4 has saveral PPMUs and each of them has operation clock which
> can be gated through CMU's SFR control.
> 
> New clocks are listed below. All clocks are added as a gate-typed clock.
> 
> CLK_PPMULEFT, CLK_PPMURIGHT, CLK_PPMUCAMIF, CLK_PPMUTV, CLK_PPMUMFC_L,
> CLK_PPMUMFC_R, CLK_G3D, CLK_PPMUIMAGE, CLK_PPMULCD0, CLK_PPMULCD1,
> CLK_PPMUFILE, CLK_PPMUGPS, CLK_PPMUDMC0, CLK_PPMUDMC1, CLK_PPMUCPU,
> CLK_PPMUACP,
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  V2 :
>     - Change clock definition order.
> 
>  drivers/clk/samsung/clk-exynos4.c   |   19 +++++++++++++++++++
>  include/dt-bindings/clock/exynos4.h |   18 ++++++++++++++++++
>  2 files changed, 37 insertions(+)

I have already queued the original v2 you sent, just waiting for
3.16-rc1 to be released to apply. :)

Best regards,
Tomasz
