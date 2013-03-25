Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3CYBLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:11:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39551 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab3CYBLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:11:49 -0400
X-AuditID: cbfee68d-b7f786d000005188-6d-514fa453b6e8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Axel Lin'" <axel.lin@ingics.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'John Stultz'" <john.stultz@linaro.org>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Changhwan Youn'" <chaos.youn@samsung.com>,
        linux-kernel@vger.kernel.org
References: <1364048887.13141.0.camel@phoenix>
In-reply-to: <1364048887.13141.0.camel@phoenix>
Subject: RE: [PATCH] clocksource: exynos_mct: Add terminating entry for
 exynos_mct_ids table
Date: Mon, 25 Mar 2013 10:11:47 +0900
Message-id: <16f801ce28f5$b9095c20$2b1c1460$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4n0qqmMk6bdN45Sf2r6D1fKsvQpQBItJuQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ93gJf6BBud3WlocmfOV2aK9QdHi
	zG9di8u75rBZbN40ldni2IwljA5sHm0/yzzuXNvD5vHu3Dl2j74tqxg9Pm+SC2CN4rJJSc3J
	LEst0rdL4MqY/vw0W8E3toq259dYGhjPs3YxcnJICJhIzN7+jx3CFpO4cG89WxcjF4eQwDJG
	ibmH/rLDFC2Zd4ali5EDKLGIUeKEPkTNX0aJWfPfgg1iE9CQOPz+GVi9iECZRPucc0wgNrNA
	tcSbNVPBbCEBPYnlk5pZQeZwCuhLvD6nBxIWFoiTOLVzMRuIzSKgKvFj4muwcl4BW4mdK/uZ
	IWxBiR+T74GdwCygLjFlSi7EdHmJzWveMoOEJYDCj/7qQhxgJLH1xTJGiBIRiX0v3jGCXCwh
	cI9d4tD35awQqwQkvk0+xALRKyux6QAzxLOSEgdX3GCZAPQbksWzEBbPQrJ4FpINCxhZVjGK
	phYkFxQnpRcZ6hUn5haX5qXrJefnbmKERGnvDsbbB6wPMSYDbZ/ILCWanA+M8rySeENjMyML
	UxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MLpvv/cp4u6RPYfX
	615baP7nCudRvl/f9IIinXJfvnp2/ZSZM3fgVJ6CK5lxayQ1q9dc982U/bT9ypOWvBM/63Zy
	7Qz1YBZ+mz2P8x2/W4zxQYWuxSbLE5de/5VlM3vn3ohnVZ3LDoULi/hMYdr5s5Tt1oHVkQfU
	3aNcOw5N3uKsmV6ka8xe2KXEUpyRaKjFXFScCABpu4+V6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAd3gJf6BBquem1gcmfOV2aK9QdHi
	zG9di8u75rBZbN40ldni2IwljA5sHm0/yzzuXNvD5vHu3Dl2j74tqxg9Pm+SC2CNamC0yUhN
	TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHar6RQlphTChQK
	SCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmP78NFvBN7aKtufXWBoYz7N2MXJySAiY
	SCyZd4YFwhaTuHBvPVsXIweHkMAiRokT+l2MXEDmX0aJWfPfgtWzCWhIHH7/jB3EFhEok2if
	c44JxGYWqJZ4s2YqmC0koCexfFIzK8gcTgF9idfn9EDCwgJxEqd2LmYDsVkEVCV+THwNVs4r
	YCuxc2U/M4QtKPFj8j0WkFZmAXWJKVNyIabLS2xe85YZJCwBFH70VxfiACOJrS+WMUKUiEjs
	e/GOcQKj0Cwkg2YhDJqFZNAsJB0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSngGfS
	OxhXNVgcYhTgYFTi4RWo8Q8UYk0sK67MPcQowcGsJMK7oB8oxJuSWFmVWpQfX1Sak1p8iDEZ
	6M2JzFKiyfnA9JRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYxMCeVa27+61VpqnXmzJUlQdL3qlMCPXikWuxynh0ofdznj2OvjufVWzPFZyxLmXd6/Muuq
	0dUHpx2UnvveKa295RGxquq18wZ9vZkixv6xNk8eF35NjdpSrHHS5HUy+6KO5N8O190+fN7u
	da9lZ805+zUe209LaZet964p/nMpP1Cga3vwLy0lluKMREMt5qLiRABDXEySRQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> 
> The of_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/clocksource/exynos_mct.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clocksource/exynos_mct.c
> b/drivers/clocksource/exynos_mct.c
> index 203ac05..3cdafc0 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -514,6 +514,7 @@ static void __init exynos4_timer_resources(struct
> device_node *np)
>  static const struct of_device_id exynos_mct_ids[] = {
>  	{ .compatible = "samsung,exynos4210-mct", .data = (void
> *)MCT_INT_SPI },
>  	{ .compatible = "samsung,exynos4412-mct", .data = (void
> *)MCT_INT_PPI },
> +	{ }

Thanks for your pointing out. But as I know, it is not mandatory now.

Please correct me if I'm wrong.

Thanks.

- Kukjin

