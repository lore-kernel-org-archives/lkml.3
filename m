Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaLCCBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:01:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63797 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLCCBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:01:05 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-cd-547e6edfba57
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org,
        "'Paul Gortmaker'" <paul.gortmaker@windriver.com>,
        "'Ferruh Yigit'" <fery@cypress.com>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Linux PM list'" <linux-pm@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <8119438.MdkFLx3Wvh@vostro.rjw.lan>
In-reply-to: <8119438.MdkFLx3Wvh@vostro.rjw.lan>
Subject: Re: [PATCH] input / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Wed, 03 Dec 2014 11:02:21 +0900
Message-id: <001001d00e9d$2cbfdc50$863f94f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAOmyNgVALqnkwSROqiwCWWQfqKQAAAfO+w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkRfd+Xl2IwZQrkhaHF71gtDjy8TCL
	xeWFl1gtbn76xmpxedccNovPvUcYLa7tPc5sceb0JVYHDo+2pkyPnbPusntsudrO4tG3ZRWj
	x+dNch7rt2xlCmCL4rJJSc3JLEst0rdL4MpYum8yW8EFgYqz01kbGN/xdjFyckgImEjcm/mD
	DcIWk7hwbz2YLSSwlFFiziVNmJrWSb/Yuxi5gOLTGSWOnnrIDOH8YpT4/HQWC0gVm4CaxJcv
	h9lBbBGBOImfE66xgRQxC7QzSUx8Mp+pi5EDqENf4vscW5AaTgEDiZVtfWBhYQFPidZpUiAm
	i4CqxLv2TJAKXgFbib7Dh9kgbEGJH5PvgW1iFlCXmDRvETOELS+xec1bZpBWCaD4o7+6EAcY
	Sex+OZkdokREYt+Ld4wQr3xll3jfIAFiswgISHybfIgFolVWYtMBZogSSYmDK26wTGCUmIVk
	8Swki2chWTwLyYYFjCyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MQLj+PS/ZxN2MN47YH2I
	UYCDUYmH1yKuLkSINbGsuDL3EKMp0EUTmaVEk/OBySKvJN7Q2MzIwtTE1NjI3NJMSZz3tdTP
	YCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MzqJuPRt38RiLzXH8btq4e17ArIbHVbMP5On9
	ny+fOnd3l4rL6unVwcLC+99vZwnrarRo2LkiIbJ+314GNvfDlheXnN5r4JUT8GLCErFvy4o+
	MS08FMH3oGxzAldJ+oRy6crUmMh4aeGS3fdezmOcef+i99pFxl+q9ojPUuG5KPM6ISDTuOe7
	EktxRqKhFnNRcSIA0G9g794CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd37eXUhBj+7RS0OL3rBaHHk42EW
	i8sLL7Fa3Pz0jdXi8q45bBafe48wWlzbe5zZ4szpS6wOHB5tTZkeO2fdZffYcrWdxaNvyypG
	j8+b5DzWb9nKFMAW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+m+yWwF
	FwQqzk5nbWB8x9vFyMkhIWAi0TrpFzuELSZx4d56ti5GLg4hgemMEkdPPWSGcH4xSnx+OosF
	pIpNQE3iy5fDYB0iAnESPydcA+tgFmhnkpj4ZD5TFyMHUIe+xPc5tiA1nAIGEivb+sDCwgKe
	Eq3TpEBMFgFViXftmSAVvAK2En2HD7NB2IISPybfA9vELKAuMWneImYIW15i85q3zCCtEkDx
	R391IQ4wktj9cjI7RImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4ETxTGoH48oGi0OMAhyMSjy8FnF1IUKsiWXFlbmHGCU4mJVEeLOTgEK8
	KYmVValF+fFFpTmpxYcYTYH+nMgsJZqcD0xieSXxhsYmZkaWRmYWRibm5krivDdu5oYICaQn
	lqRmp6YWpBbB9DFxcEo1MG5ePHElW5eNzJuAqO/3HBfM2fqx7WF1QDQf2xl+ZqeKfsakcF4u
	A/sNzsmMR4S2uK//eEcr84fn5EuGAhczb6zeIF7buevLDnnm1++/vz+6qSzVQV9zfyr7vJM3
	05tOvN9sNzs1U7r54GTHC/mvn59ge2o2g29R85a8y5tzHWoP/Qg5LmBS/l6JpTgj0VCLuag4
	EQCmIT5QKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 03, 2014 11:09 AM, Rafael J. Wysocki wrote:
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> The alternative of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME may be
> replaced with CONFIG_PM too.
> 
> Make these changes in 2 files under drivers/input/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.
> 
> ---
>  drivers/input/keyboard/samsung-keypad.c  |    2 +-
>  drivers/input/touchscreen/cyttsp4_core.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-pm/drivers/input/keyboard/samsung-keypad.c
> ===================================================================
> --- linux-pm.orig/drivers/input/keyboard/samsung-keypad.c
> +++ linux-pm/drivers/input/keyboard/samsung-keypad.c
> @@ -463,7 +463,7 @@ static int samsung_keypad_remove(struct
>  	return 0;
>  }
> 
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int samsung_keypad_runtime_suspend(struct device *dev)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
> Index: linux-pm/drivers/input/touchscreen/cyttsp4_core.c
> ===================================================================
> --- linux-pm.orig/drivers/input/touchscreen/cyttsp4_core.c
> +++ linux-pm/drivers/input/touchscreen/cyttsp4_core.c
> @@ -1716,7 +1716,7 @@ static void cyttsp4_free_si_ptrs(struct
>  	kfree(si->btn_rec_data);
>  }
> 
> -#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
> +#ifdef CONFIG_PM
>  static int cyttsp4_core_sleep(struct cyttsp4 *cd)
>  {
>  	int rc;

