Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3LRPve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:51:34 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19448 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab3LRPva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:51:30 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-c4-52b1c47f9c9a
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH v11 1/4] thermal: samsung: replace inten_ bit fields with
 intclr_
Date: Wed, 18 Dec 2013 16:51:12 +0100
Message-id: <22385645.8hSP6uLh4A@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1386657688-21542-1-git-send-email-ch.naveen@samsung.com>
References: <1384238168-24561-1-git-send-email-ch.naveen@samsung.com>
 <1386657688-21542-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xa7oNRzYGGShbNFwNsdg4Yz2rxd3n
	hxktXh7StJh/5ByrxZr9P5ksehdcZbO4vGsOm8Xn3iOMFjPO72OyWLTtP7PFk4d9bA48Hjtn
	3WX3WLznJZNH35ZVjB7Hb2xn8vi8SS6ANYrLJiU1J7MstUjfLoErY87RzywF63kqJk+TamDs
	4upi5OSQEDCRuLXnOhuELSZx4d56IJuLQ0hgKaNEx5tfLBBOF5NE/6uz7CBVbAJqEp8bHoF1
	iAB1H391hh2kiFlgKZPE/GWLmEESwgLhEj0nH7OC2CwCqhJXp20Da+YV0JLoPvGaEcTmF1CX
	eLftKROILSrgJvFi3xawGk4g+/rB71BnNDJKzJh7B6pZUOLH5HssIDazgLzEvv1TWSFsLYn1
	O48zTWAUnIWkbBaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECImVrzsYlx6z
	OsQowMGoxMO7wGdjkBBrYllxZe4hRgkOZiURXqGtQCHelMTKqtSi/Pii0pzU4kOMTBycwHDV
	3u8/q8SV5+qZgnDG0N3XD0mX7DD4fnBnq3e+GouETdi+3yXT/tx9b8zBenpO/QTt5lnpPD2O
	P+57zX78Z9czpq/6UUaVT9h3VGqI6W9+rpbWm75pp2PwseSAR5mvO4+833g72+C32d85hdc1
	74kvNa24fiv008a4xmN7jh7ZlrGg4GepxtQ5SizFGYmGWsxFxYkA3iNUIXMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 of December 2013 12:11:28 Naveen Krishna Chatradhi wrote:
> This patch replaces the inten_rise_shift/mask and inten_fall_shift/mask
> with intclr_rise_shift/mask and intclr_fall_shift/mask respectively.
> Currently, inten_rise_shift/mask and inten_fall_shift/mask bits are only used
> to configure intclr related registers.
> 
> Description of H/W:
> The offset for the bits in the CLEAR register are not consistent across TMU
> modules in Exynso5250, 5420 and 5440.
> 
> On Exynos5250, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT registers and at an offset of
> 12 in INTCLEAR register.
> 
> On Exynos5420, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT and INTCLEAR registers.
> 
> On Exynos5440,
> the FALL_IRQEN bits are at an offset of 4
> and the RISE_IRQEN bits are at an offset of 0
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> Changes since v10:
> None
> 
>  drivers/thermal/samsung/exynos_tmu.c      |    6 +++---
>  drivers/thermal/samsung/exynos_tmu.h      |   16 ++++++++--------
>  drivers/thermal/samsung/exynos_tmu_data.c |   18 +++++++++---------
>  drivers/thermal/samsung/exynos_tmu_data.h |    4 ++--
>  4 files changed, 22 insertions(+), 22 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

