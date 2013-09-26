Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab3IZEgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:36:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44008 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3IZEgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:36:35 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-82-5243b9d1ae17
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mateusz Krawczuk'" <m.krawczuk@partner.samsung.com>, t.figa@samsung.com,
        linus.walleij@linaro.org
Cc: thomas.abraham@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1380035051-24526-1-git-send-email-m.krawczuk@partner.samsung.com>
In-reply-to: <1380035051-24526-1-git-send-email-m.krawczuk@partner.samsung.com>
Subject: RE: [PATCH] pinctrl: Correct number of pins for s5pv210
Date: Thu, 26 Sep 2013 13:36:33 +0900
Message-id: <02bc01ceba71$fa8bcda0$efa368e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65N1rqN81L59WzRsOb8TZnOPE6fABOjgvg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zQ92LO52DDJ7fsbI42/SG3WLKn+VM
	FpseX2O1uLxrDpvFjPP7mCxOrznFbLF+xmsWi2MzljA6cHjcubaHzWPzknqPg+/2MHn0bVnF
	6PF5k1wAaxSXTUpqTmZZapG+XQJXRtve4oIP/BVvPi9na2DcxdvFyMkhIWAisfP6KWYIW0zi
	wr31bF2MXBxCAssYJf5tOscKU3T/zzqoxHRGieUb1zJDOH8ZJX5u+MsOUsUmoCFx+P0zMFtE
	IF3i+bJTrCBFzAJbGSWmPpgA1M4B1OEnseW+AYjJKeAvMWerOEi5sICDxNUjfUwgNouAqsSj
	l1PAFvMK2ErMPrGVBcIWlPgx+R6YzSygJbF+53EmCFteYvOat8wgIyUE1CUe/dWFuMBIYsHn
	FjaIEhGJfS/eMYJcIyHwkV3i1fppLBC7BCS+TT7EAtErK7HpADQgJCUOrrjBMoFRYhaSzbOQ
	bJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ4f4djHcPWB9iTAZaP5FZ
	SjQ5H5gC8kriDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXA6KXQmNQav+rfZJFn1z6GLvRMvJSk5S3NGlv4d4230u6ti+ZZhm6bsuPLV51en2e/PjGn
	BxparZm6WePMidhn5UKTb9Q+8pm/3dAy69G999bRHJtelQmofo7mTnq643zUiqsqdx5q3pV7
	8PbS+Z81E5kFj3NKyOTKSpv8dO+IKE6bce4ee3VzsRJLcUaioRZzUXEiAPzS7Gr3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd2LO52DDFa1mFmcbXrDbjHlz3Im
	i02Pr7FaXN41h81ixvl9TBan15xitlg/4zWLxbEZSxgdODzuXNvD5rF5Sb3HwXd7mDz6tqxi
	9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6BYlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY0bb3uKCD/wVbz4v
	Z2tg3MXbxcjJISFgInH/zzo2CFtM4sK99UA2F4eQwHRGieUb1zJDOH8ZJX5u+MsOUsUmoCFx
	+P0zMFtEIF3i+bJTrCBFzAJbGSWmPpgA1M4B1OEnseW+AYjJKeAvMWerOEi5sICDxNUjfUwg
	NouAqsSjl1NYQWxeAVuJ2Se2skDYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZZKSEgLrEo7+6
	EBcYSSz43MIGUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4
	NC9dLzk/dxMjOEE8k97BuKrB4hCjAAejEg/vBWbnICHWxLLiytxDjBIczEoivN+MgEK8KYmV
	ValF+fFFpTmpxYcYk4EencgsJZqcD0xeeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8s
	Sc1OTS1ILYLZwsTBKdXAqH7uxy/N/oi1a5yl1LvPyBy2f3as65zRRqX0W2aP3uT2SZxJMn3T
	F65g/7B/bf7C+NW7fc4WK+z1N+Qxfj3V1JXNxERsaa35kowge9Z7pkmtl52qov5eOlpVvnn7
	2nvWXF0lH1+tEnnl8b1aNbuC8cO6xkeT6m7w/5toocvArsct+lXpZd0JJZbijERDLeai4kQA
	piqqsFQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mateusz Krawczuk wrote:
> 
> Values of pins in table s5pv210 bank are incorrect. This patch correct
> values.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

This fix is correct,

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

> ---
>  drivers/pinctrl/pinctrl-exynos.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-
> exynos.c
> index 2689f8d..155b1b3 100644
> --- a/drivers/pinctrl/pinctrl-exynos.c
> +++ b/drivers/pinctrl/pinctrl-exynos.c
> @@ -663,18 +663,18 @@ static void exynos_pinctrl_resume(struct
> samsung_pinctrl_drv_data *drvdata)
>  /* pin banks of s5pv210 pin-controller */
>  static struct samsung_pin_bank s5pv210_pin_bank[] = {
>  	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
> -	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpa1", 0x04),
>  	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
>  	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
>  	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
>  	EXYNOS_PIN_BANK_EINTG(4, 0x0a0, "gpd0", 0x14),
> -	EXYNOS_PIN_BANK_EINTG(4, 0x0c0, "gpd1", 0x18),
> -	EXYNOS_PIN_BANK_EINTG(5, 0x0e0, "gpe0", 0x1c),
> -	EXYNOS_PIN_BANK_EINTG(8, 0x100, "gpe1", 0x20),
> -	EXYNOS_PIN_BANK_EINTG(6, 0x120, "gpf0", 0x24),
> +	EXYNOS_PIN_BANK_EINTG(6, 0x0c0, "gpd1", 0x18),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x0e0, "gpe0", 0x1c),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x100, "gpe1", 0x20),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x120, "gpf0", 0x24),
>  	EXYNOS_PIN_BANK_EINTG(8, 0x140, "gpf1", 0x28),
>  	EXYNOS_PIN_BANK_EINTG(8, 0x160, "gpf2", 0x2c),
> -	EXYNOS_PIN_BANK_EINTG(8, 0x180, "gpf3", 0x30),
> +	EXYNOS_PIN_BANK_EINTG(6, 0x180, "gpf3", 0x30),
>  	EXYNOS_PIN_BANK_EINTG(7, 0x1a0, "gpg0", 0x34),
>  	EXYNOS_PIN_BANK_EINTG(7, 0x1c0, "gpg1", 0x38),
>  	EXYNOS_PIN_BANK_EINTG(7, 0x1e0, "gpg2", 0x3c),
> --
> 1.8.1.2

