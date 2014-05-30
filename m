Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaE3Kco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:32:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42342 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaE3Kcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:32:43 -0400
X-AuditID: cbfee690-b7fb56d000003439-c5-53885e44cdc8
Message-id: <53885E43.2000000@samsung.com>
Date: Fri, 30 May 2014 19:32:35 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: lee.jones@linaro.org, broonie@kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, sbkim73@samsung.com,
        sameo@linux.intel.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, jonghwa3.lee@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [PATCHv2 0/3] regulator: s2mps11: Add support S2MPU02 PMIC device
References: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkSNclriPYYMERDoupD5+wWVz/8pzV
	ovPsE2aL1y8MLc42vWG3uP/1KKPFtysdTBaXd81hs7jduILN4nQ3q8XFFV+YHLg9ds66y+6x
	aVUnm8eda3vYPOadDPTo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujDd7ZzMVdIpVvLlX08B4
	QrCLkZNDQsBEYt++v0wQtpjEhXvr2boYuTiEBJYySmxtu84CU7Rwyi12EFtIYDqjxOJJNhBF
	rxklph6cxgaS4BXQktjbtZgRxGYRUJV4+fYlM4jNBhTf/+IGWI2oQJjEyulXWCDqBSV+TL4H
	ZHNwiAjoSFy/kQ4yk1ngK6PEl5bPYBcJC/hJ9Kz7ygKx2FXi/NGdYDangJvE/u7bYDYzUO/+
	VogbmAXkJTavecsMMkhC4C27RPep3UwQBwlIfJt8CGyZhICsxKYDzBCPSUocXHGDZQKj2Cwk
	J81CMnYWkrELGJlXMYqmFiQXFCelF5noFSfmFpfmpesl5+duYgRG6Ol/zybsYLx3wPoQYzLQ
	yonMUqLJ+cAIzyuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1RUpCQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGRkXXUC/Py6fyi48nN/9WeDRFia14X4b5C2WWopMhYWkvZmXX71pyUpT9Y+WZlIKq
	iPXLghnYjHZztMsofn7F/kz06M4FAZfZ338yFpWwK3wZ4XR3CvcKjVdJvK370qpbH00t8d67
	beHLc1vLuAts/uae3X9x2kfh6NhLr5c/bOLa+f3Euf377JVYijMSDbWYi4oTAePaxR3mAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQV2XuI5ggw+hFlMfPmGzuP7lOatF
	59knzBavXxhanG16w25x/+tRRotvVzqYLC7vmsNmcbtxBZvF6W5Wi4srvjA5cHvsnHWX3WPT
	qk42jzvX9rB5zDsZ6NG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAxykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM97snc1U0ClW8eZeTQPjCcEuRk4OCQETiYVTbrFD2GISF+6tZwOxhQSmM0osnmTT
	xcgFZL9mlJh6cBpYgldAS2Jv12JGEJtFQFXi5duXzCA2G1B8/4sbYDWiAmESK6dfYYGoF5T4
	MfkekM3BISKgI3H9RjrITGaBr4wSX1o+M4HUCAv4SfSs+8oCsdhV4vzRnWA2p4CbxP7u22A2
	M1Dv/laIG5gF5CU2r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5y
	fu4mRnD0P5PewbiqweIQowAHoxIP74T09mAh1sSy4srcQ4wSHMxKIrwOMR3BQrwpiZVVqUX5
	8UWlOanFhxiTgSEwkVlKNDkfmJjySuINjU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2a
	WpBaBLOFiYNTqoHR5xq3Vd2idFG1iY3ft12VuhyX+urU9+lzdnF9mmup3qW5vChQ965jlOfM
	xrayf29CLW77/+55rsG9v0fUK2aGKPv0K2Hnzj+6s1vkSoTxxIkxtkWLfBZtuM3qmLR30uZ3
	iSvt/555spR/oseW7G91nPeZnFYWOovofpx2xvZZ5IvPNROW+a1SVGIpzkg01GIuKk4EADeY
	IrdCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Lee Jones and Mark Brown,

The patch[1] has dependency on both mfd.git and regulator.git.
[1] regulator: s2mps11: Add support S2MPU02 regulator device

The mfd.git(for-mfd-next branch) has only following patchset[2] without patchset[3] about drivers/mfd/sec-core.c.
The regulaotr.git (for-next branch) has only following patchset[3] without patchset[2] about driver/regulator/s2mps11.c.

[2] patchset for drivers/mfd/sec-core.c
2014-05-13 12:58 Krzysztof Kozlows~ o mfd: sec-core: Make of_device_id array const
2014-04-22 16:00 Krzysztof Kozlows~ o mfd: sec-core: Fix IRQ handling after resume if this is not a wakeup source
2014-04-23 16:13 Krzysztof Kozlows~ o mfd: sec-core: Remove duplicated device type from sec_pmic_dev
2014-04-14 09:40 Krzysztof Kozlows~ o mfd/rtc: s5m: Do not allocate RTC I2C dummy and regmap for unsupported chipsets

[3] patchset for drivers/regulator/s2mps11.c
2014-05-06 08:37 Krzysztof Kozlows~ o regulator: s2mps11: Fix accidental enable of buck6 ramp delay
2014-04-30 10:40 Krzysztof Kozlows~ o regulator: s2mps11: Allow GPIO 0 to be used as external control on S2MPS14
2014-04-14 10:09 Krzysztof Kozlows~ o regulator: s2mps11: Add external GPIO control for S2MPS14
2014-04-14 10:09 Krzysztof Kozlows~ o regulator: s2mps11: Move DTS parsing code to separate function

Should I divide patch[1] into two patches to remove dependency on both mfd.git and regulator.git?

Best Regards,
Chanwoo Choi

On 05/30/2014 09:25 AM, Chanwoo Choi wrote:
> This patch add Samsung S2MPU02 PMIC device driver in exiting S2MPS11 PMIC
> driver because S2MPU02 has a little different between S2MPU02 and S2MPS1x.
> The S2MPU02 PMIC has LDO[1-28] and BUCK[1-7] regulators.
> 
> Changes from v1:
> - Fix typo about patch description
> - Use existing suspend_state variable instead of defining new variable for S2MPU02
> - Remove unnecessary parameter of s2mps11_pmic_dt_parse()
> - Remove unfit comment of s2mpu02.h file
> - Both patch2 and patch3 should be squashed on patch2
> 
> Chanwoo Choi (3):
>   mfd: sec-core: Add support for S2MPU02 device
>   regulator: s2mps11: Add support S2MPU02 regulator device
>   dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
> 
>  Documentation/devicetree/bindings/mfd/s2mps11.txt |   7 +-
>  drivers/mfd/sec-core.c                            |  45 +++
>  drivers/mfd/sec-irq.c                             |  88 ++++++
>  drivers/regulator/s2mps11.c                       | 319 ++++++++++++++++++++--
>  include/linux/mfd/samsung/core.h                  |   1 +
>  include/linux/mfd/samsung/irq.h                   |  24 ++
>  include/linux/mfd/samsung/s2mpu02.h               | 200 ++++++++++++++
>  7 files changed, 662 insertions(+), 22 deletions(-)
>  create mode 100644 include/linux/mfd/samsung/s2mpu02.h
> 

