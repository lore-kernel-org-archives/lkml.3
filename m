Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab3FAEJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:09:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30969 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3FAEIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:08:53 -0400
X-AuditID: cbfee68f-b7f436d000000f81-dc-51a973d39eef
From: Jingoo Han <jg1.han@samsung.com>
To: "'Shuah Khan'" <shuah.kh@samsung.com>, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        rafael.j.wysocki@intel.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Jingoo Han <jg1.han@samsung.com>
References: <2236503749-2998-1-git-send-email-shuah.kh@samsung.com>
In-reply-to: <2236503749-2998-1-git-send-email-shuah.kh@samsung.com>
Subject: Re: [PATCH] backlight: Convert from Legacy pm ops to dev_pm_ops
Date: Sat, 01 Jun 2013 13:08:50 +0900
Message-id: <005801ce5e7d$b9225140$2b66f3c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG97VEapjnOCkuRBiG3DpwhyCj275lBHrjA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zfd3LxSsDDaZcFLDonHmN0eLywkus
	Fif6PrBaXN41h81i3cMXTBaPV7xlt9i96ymrxZfPXBZffzpYrJ9/i82By2PnrLvsHh8+xnks
	3vOSyePVhTssHnvm/2D16NuyitHj+I3tTB6fN8kFcERx2aSk5mSWpRbp2yVwZbxcuYGx4DZ/
	xdZfhg2M73m6GDk5JARMJCZNmMsGYYtJXLi3HswWEljGKPHyKBNMzZxluxm7GLmA4tMZJR71
	dLBCOL8YJY4c/MACUsUmoCbx5cthdpCEiMAiRok789qZQRLMAmUS347sZ4IY6yyx5PMhdhCb
	U8BFYvWCdWBxYQEPibuXr4HFWQRUJe48WQVm8wpYShzobmOGsAUlfky+xwIxU0ti/c7jTBC2
	vMTmNW+ZIU5VkNhx9jUjiC0iYCTxfN1KNogaEYl9L96BvSAhMJVD4undLiaIZQIS3yYfAhrK
	AZSQldh0AGqOpMTBFTdYJjBKzEKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRcZ6xYm5xaV5
	6XrJ+bmbGCFR37+D8e4B60OMyUDrJzJLiSbnA5NGXkm8obGZkYWpiamxkbmlGWnCSuK8ai3W
	gUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYZ873rFll8dJu4crv23ps0j41Bcse0mffuVy4
	cNulahNptX/mmz2TNVqZNu0QTWGokOSVyV+W2f56Qt3P/qcHBLmOLDj1bOHEn76L+3Xrvuem
	aHoeO/i8S1f0sPq+dUn9jzYJ8VaJuh2J3fm+YWvAGmHDxE/55YknXGYYt9WHLbDqDqr83Bmq
	xFKckWioxVxUnAgAIqOF1xADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jQd3LxSsDDZbM4bLonHmN0eLywkus
	Fif6PrBaXN41h81i3cMXTBaPV7xlt9i96ymrxZfPXBZffzpYrJ9/i82By2PnrLvsHh8+xnks
	3vOSyePVhTssHnvm/2D16NuyitHj+I3tTB6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rfDNCE0xE3XAqYx
	Qtc3JAiux8gADSSsY8x4uXIDY8Ft/oqtvwwbGN/zdDFyckgImEjMWbabEcIWk7hwbz1bFyMX
	h5DAdEaJRz0drBDOL0aJIwc/sIBUsQmoSXz5cpgdJCEisIhR4s68dmaQBLNAmcS3I/uZQGwh
	AWeJJZ8PsYPYnAIuEqsXrAOLCwt4SNy9fA0sziKgKnHnySowm1fAUuJAdxszhC0o8WPyPRaI
	mVoS63ceZ4Kw5SU2r3nLDHGqgsSOs6/BzhYRMJJ4vm4lG0SNiMS+F+8YJzAKzUIyahaSUbOQ
	jJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCk8kxqB+PKBotDjAIcjEo8vAYr
	VgQKsSaWFVfmHmKU4GBWEuHNnwMU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgwssriTc0
	NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsZjB9ccDLLvrNw/13aX
	jMp+ntLPcc2/bzdnumjk6D3aETLrn4CjlobMLetZiw0Tfv69eKph0lq79ARhpln9WYuuP23d
	lXprS2VTRb3Jx1MKKs9eBjyzZWk59SL6kXX+8wVBE6fxlr093bs3zNBMcm3fIZkFN7ZOeKnA
	XLPytrBYwx9GtcvCbY5KLMUZiYZazEXFiQDiv+uGbgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 14, 2040 8:02 PM, Shuah Khan wrote:
> 
> Convert drivers/video/backlight/class to use dev_pm_ops for power
> management and remove Legacy PM ops hooks. With this change, rtc class

No, this is a backlight class, not rtc class.

Please fix the typo as below:
  rtc class -> backlight class.


> registers suspend/resume callbacks via class->pm (dev_pm_ops) instead of
> Legacy class->suspend/resume. When __device_suspend() runs call-backs,
> it will find class->pm ops for the rtc class.

Same here.


Best regards,
Jingoo Han

> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> Cc: Shuah Khan <shuahkhan@gmail.com>
> ---
>  drivers/video/backlight/backlight.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index c74e7aa..0ffb251 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -208,7 +208,7 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
> 
>  static struct class *backlight_class;
> 
> -static int backlight_suspend(struct device *dev, pm_message_t state)
> +static int backlight_suspend(struct device *dev)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
> 
> @@ -236,6 +236,9 @@ static int backlight_resume(struct device *dev)
>  	return 0;
>  }
> 
> +static SIMPLE_DEV_PM_OPS(backlight_class_dev_pm_ops, backlight_suspend,
> +			 backlight_resume);
> +
>  static void bl_device_release(struct device *dev)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
> @@ -414,8 +417,7 @@ static int __init backlight_class_init(void)
>  	}
> 
>  	backlight_class->dev_attrs = bl_device_attributes;
> -	backlight_class->suspend = backlight_suspend;
> -	backlight_class->resume = backlight_resume;
> +	backlight_class->pm = &backlight_class_dev_pm_ops;
>  	return 0;
>  }
> 
> --
> 1.7.10.4
> 
> --


