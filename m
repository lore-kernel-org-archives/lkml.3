Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaF3Nsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:48:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14976 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaF3NsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:48:18 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-b1-53b16a9e1c08
Message-id: <53B16A7E.7020208@samsung.com>
Date: Mon, 30 Jun 2014 15:47:42 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, mturquette@linaro.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] clk: exynos4: Add PPMU IP block source clocks.
References: <1401190028-21020-1-git-send-email-jonghwa3.lee@samsung.com>
In-reply-to: <1401190028-21020-1-git-send-email-jonghwa3.lee@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xq7rzsjYGG6yfrmVx/ctzVovOs0+Y
	LS7vmsNmMeP8PiaLpxMuslncblzB5sDmcefaHjaPvi2rGD0+b5ILYI7isklJzcksSy3St0vg
	ylhwq6pgNnvFu8XTWRoY/7B2MXJySAiYSMw8vYIRwhaTuHBvPVsXIxeHkMBSRomp/85BOZ8Z
	JRbeewHWwSugJXHt/G4wm0VAVeJd0yswm01ATeJzwyM2EJsfqGZN03WWLkYODlGBCInHF4Qg
	WgUlfky+xwJiiwh4SNxv7WQBmc8s0Mso0T13AhNIQljATWLvrSVgthBQ0fp7J5hB5nAKeEos
	vJEOEmYW0JHY3zqNDcKWl9i85i3zBEbBWUhWzEJSNgtJ2QJG5lWMoqmlyQXFSem5RnrFibnF
	pXnpesn5uZsYIcH9dQfj0mNWhxgFOBiVeHgttmwIFmJNLCuuzD3EKMHBrCTCe9NnY7AQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGxkurTgR9f6Z2a2KFC//qRw0x0pPjhR80nPRjevEnueyO+G+5
	FbfPfrm3IqP5efZc3l2iLZctL3RkBbHu/5Z9qfCUwLmTKRcZb/9kn/3T6LayuuW12bptKX48
	iXdMdGr0ahcunfL9yZeq46amxQVa5yZ4bbL89/0bR1O4/wHrHY77pY983mIv90KJpTgj0VCL
	uag4EQC0C7EeTAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2014 13:27, Jonghwa Lee wrote:
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
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  V2 :
>     - Change clock definition order.
> 
>  drivers/clk/samsung/clk-exynos4.c   |   19 +++++++++++++++++++
>  include/dt-bindings/clock/exynos4.h |   18 ++++++++++++++++++
>  2 files changed, 37 insertions(+)

Applied for v3.17.

Best regards,
Tomasz
