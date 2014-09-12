Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaILM0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:26:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36624 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaILM0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:26:17 -0400
X-AuditID: cbfee690-f79ce6d00000115a-8d-5412e6664e31
From: kgene@kernel.org
To: "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Naveen Krishna Chatradhi'" <ch.naveen@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Andreas Faerber'" <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
References: <1410344391-5675-1-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1410344391-5675-1-git-send-email-javier.martinez@collabora.co.uk>
Subject: RE: [PATCH v3 0/7] Add max77802 support for Peach boards
Date: Fri, 12 Sep 2014 21:26:13 +0900
Message-id: <0ae801cfce84$be443620$3acca260$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDdE+QFarDupi/VKLj8ojkzjiJxFp3i4RRg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zA920Z0IhBgcmm1k0byq2mPrwCZvF
	3eeHGS3OLjvIZtF25SC7xdHfBRabHl9jtbi8aw6bxYzz+5gsTl3/zGYxZdFhVgduj9kNF1k8
	/j6/zuKxaVUnm8fmJfUeV040sXr0bVnF6LH5dLXH501yARxRXDYpqTmZZalF+nYJXBnr375m
	K7gkWNFy8BtbA+Mr3i5GTg4JAROJ6ZsOsUHYYhIX7q0Hsrk4hASWMUp8Xb6IHaZo/sllrBCJ
	RYwS6z6vg3L+MkqsejebqYuRg4MNqH3qE2mQBmEBLYmFW5pYQGwRAQeJ8y9Og01lFpjCLHFr
	6lmwhJCAn8Sqv0uZQWxOAX+JybemsIPMERZwlHg0pRzEZBFQldi+3AikglfAQmLW6+lMELag
	xI/J98CmMAOtWr/zOBOELS+xec1bZoibFSR2nH3NCHGCkcSMC6eYIWpEJPa9eMcIco6EwFIO
	ie1N61lBEiwCAhLfJh9iAdkrISArsekA1BxJiYMrbrBMYJSchWT1LCSrZyFZPQvJigWMLKsY
	RVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQlLChB2M9w5YH2IU4GBU4uGtYBEMEWJNLCuuzD3E
	aAp00URmKdHkfGDiySuJNzQ2M7IwNTE1NjK3NFMS530t9TNYSCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA+PSp3uNynJ+3C0V6Lnp/erqHvmj9/tcPs95LvrsoqPAzn3lYl/2CUy83Xpt2s1D
	gsv7TFjkHac9+FOZzT7h+2KG3qs7z0p3yXvWKZ2eVM+UdVW3WO9GiANP0NpLc3LWFjs36v4w
	shXJcvIwXtwYdtDw7HxhpR2ft7s6RWgEPNiqfi1jvbir2QolluKMREMt5qLiRABDT3/dBAMA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jAd20Z0IhBkcnG1o0byq2mPrwCZvF
	3eeHGS3OLjvIZtF25SC7xdHfBRabHl9jtbi8aw6bxYzz+5gsTl3/zGYxZdFhVgduj9kNF1k8
	/j6/zuKxaVUnm8fmJfUeV040sXr0bVnF6LH5dLXH501yARxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBnKimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgz1r99zVZwSbCi5eA3tgbGV7xdjJwcEgImEvNPLmOFsMUkLtxb
	z9bFyMUhJLCIUWLd53WsEM5fRolV72YzdTFycLABVU19Ig3SICygJbFwSxMLiC0i4CBx/sVp
	sGZmgSnMEremngVLCAn4Saz6u5QZxOYU8JeYfGsKO8gcYQFHiUdTykFMFgFVie3LjUAqeAUs
	JGa9ns4EYQtK/Jh8D2wKM9Cq9TuPM0HY8hKb17xlhrhZQWLH2deMECcYScy4cIoZokZEYt+L
	d4wTGIVnIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcMJ5JrWD
	cWWDxSFGAQ5GJR7eChbBECHWxLLiytxDjBIczEoivLvuCIUI8aYkVlalFuXHF5XmpBYfYjQF
	enQis5Rocj4wGeaVxBsam5gZWRqZWRiZmJsrifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamBM
	2hlh+GKSp1/PvtY2B+MlOZv5n7u+ql3O9uyo8v01PMIsM4LWzPD4+fOxpBKP+NEPpw4mnzpd
	dPiRy8VD204HThLS9zO8qlW8MHtFe8Wfn3umiqtYch9+1nW/4WFvusl5J03LK57rL9U+3/T1
	YS3bvYhX3/6pnvhvVsc+w+NqdXqDCIOo63N1JZbijERDLeai4kQAME1T2E4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas wrote:
> 
> Hello Kukjin,
> 
Hi Javier,

> This is a third version of th series that adds max77802 support for
> the Peach Pit and Pi boards. The series also have all the pending
> patches that were posted but depended on this support. I've picked
> all the patches I found and rebased them to be sure that they apply
> cleanly on top of linux-next. Also I've taken some DT snippets from
> the downstream Chrome OS 3.8 kernel DTS for devices that use one of
> these regulators as their input supply.
> 
Thanks a lot and looks good to me. I'll take this whole series.

- Kukjin

> Changes since v2 [0]:
>  - Remove left over supply on ldo35 regulator, suggested by Doug Anderson.
>  - Add a patch to change the i2c7 clock at 400kHz, suggested by Doug Anderson.
>  - Add a patch from Vivek Gautam to enable max77802 regulator driver support.
> 
> Changes sinve v1 [1]:
>  - Dropped patch that added vmmc and vqmmc supplies as suggested
>    by Doug Anderson.
>  - Use IRQ flags define instead of a magic number as suggested by
>    Andreas Faerber.
> 
> The series is composed of the following patches:
> 
> Javier Martinez Canillas (3):
>   ARM: dts: Add Peach Pit and Pi dts entry for max77802 PMIC
>   ARM: dts: Add Peach Pit and Pi dts entry for ISL29018 sensor
>   ARM: dts: Set i2c7 clock at 400kHz for Peach boards
> 
> Naveen Krishna Chatradhi (1):
>   ARM: dts: Add thermistor dts fragment used by exynos based Peach
>     boards
> 
> Rahul Sharma (2):
>   ARM: dts: add hdmi regulators for exynos5800 based peach-pi board
>   ARM: dts: add hdmi regulators for exynos5420 based peach-pit board
> 
> Vivek Gautam (1):
>   ARM: exynos_defconfig: Enable MAX77802
> 
>  arch/arm/boot/dts/cros-adc-thermistors.dtsi |  44 ++++
>  arch/arm/boot/dts/exynos5420-peach-pit.dts  | 389 ++++++++++++++++++++++++++++
>  arch/arm/boot/dts/exynos5800-peach-pi.dts   | 389 ++++++++++++++++++++++++++++
>  arch/arm/configs/exynos_defconfig           |   3 +
>  4 files changed, 825 insertions(+)
>  create mode 100644 arch/arm/boot/dts/cros-adc-thermistors.dtsi
> 
> 
> Best regards,
> Javier
> 
> [0]: https://lkml.org/lkml/2014/8/20/225
> [1]: https://lkml.org/lkml/2014/8/19/372

