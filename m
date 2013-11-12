Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3KLASL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:18:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8892 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3KLASG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:18:06 -0500
X-AuditID: cbfee691-b7f866d000001b8c-7b-528173bd6801
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, kay@vrfy.org,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
References: <20131111235700.GA29987@july>
In-reply-to: <20131111235700.GA29987@july>
Subject: Re: [PATCH] video: backlight: Remove backlight sysfs uevent
Date: Tue, 12 Nov 2013 09:18:04 +0900
Message-id: <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7fOavfpiiNdH9mR/ymw66mQWj6SwAAgyKQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zY929xY1BBotXsFvMPmxjMefZWkaL
	ywsvsVrcWvWc3eLW5VUsFif6PrBaXN41h81i9Z4XzBa7dz1ldeD0+H2A0WPzCi2P3Qs+M3ns
	mf+D1aNvyypGj8+b5Dw+rvcMYI/isklJzcksSy3St0vgyvj/bhJrwR/hilWzbrA1MHYLdDFy
	ckgImEis2LeBGcIWk7hwbz1bFyMXh5DAMkaJD3+vs8EU/Z7xkxEiMZ1R4uvDh1DOL0aJQ4dX
	sINUsQmoSXz5chjMFhFIlFh5bgUTiM0s8IRRYttkdRBbSEBTYs6JLrB1nAJaEjNWPAOrERZw
	kZiz8S5YL4uAqsTz1+/B4rwCthLrfy1nh7AFJX5MvscCMVNLYv3O41Dz5SU2r3kLNJMD6FJ1
	iUd/dSFOMJJoWbgGqlxEYt+Ld2A3Swg0cki03zjFDLFLQOLb5EMsEL2yEpsOQENCUuLgihss
	ExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJD4nriD8f4B
	60OMyUDrJzJLiSbnA9NDXkm8obGZkYWpiamxkbmlGWnCSuK86Y+SgoQE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwMnAZlSf2b2ZueCnQ+PvPmus3TX//eRe+2IFHttw416gz4myIZ84d3wez
	dDtY1SKlYj+rPax4WuNo8mPvx2l8B/WaLL5KrGq7o3mbfTaH1xOWDT7r128OX7yE9XjCuWO9
	Ou/uP960w12Be+FyM48bhnu8tjWU/pd7ZnetRv//7evzFxz83ercp8RSnJFoqMVcVJwIACDH
	SlkFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jQd29xY1BBieuM1nMPmxjMefZWkaL
	ywsvsVrcWvWc3eLW5VUsFif6PrBaXN41h81i9Z4XzBa7dz1ldeD0+H2A0WPzCi2P3Qs+M3ns
	mf+D1aNvyypGj8+b5Dw+rvcMYI9qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQw
	V1LIS8xNtVVy8QnQdcvMAbpLSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhY
	x5jx/90k1oI/whWrZt1ga2DsFuhi5OSQEDCR+D3jJyOELSZx4d56ti5GLg4hgemMEl8fPmSE
	cH4xShw6vIIdpIpNQE3iy5fDYLaIQKLEynMrmEBsZoEnjBLbJquD2EICmhJzTnQxg9icAloS
	M1Y8A6sRFnCRmLPxLlgvi4CqxPPX78HivAK2Eut/LWeHsAUlfky+xwIxU0ti/c7jUPPlJTav
	eQs0kwPoUnWJR391IU4wkmhZuAaqXERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFy
	QXFSeq6RXnFibnFpXrpecn7uJkZw8ngmvYNxVYPFIUYBDkYlHt4dXI1BQqyJZcWVuYcYJTiY
	lUR4zXOBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTGx5JfGGxiZmRpZGZhZGJubmpAkr
	ifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cAoW6Ypapq6Y//jPc09DrvvNjUntV82nPw69Pn5
	FXM2SF/0C9Zi9e9YuMB2+mXxHTvPPG5mN3A721duNNO1derEGXyuu8+/Onz1+DuNqE/rmnlP
	BW1++DrufIWx3KpXmQd3r+YU2PRUSytywpIX3x/HchQn2s5devKI/RRZxu2uyy1Upk/cpLi8
	TomlOCPRUIu5qDgRAC7WMi9iAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 12, 2013 8:57 AM, Kyungmin Park wrote:
> 
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> The most mobile phones have Ambient Light Sensors and it changes brightness according lux.
> It means it changes backlight brightness frequently by just writing sysfs node, so it generates uevent.
> 
> Usually there's no user to use this backlight changes. But it forks udev worker threads and it takes
> about 5ms. The main problem is that it hurts other process activities. so remove it.
> 
> Kay said
> "Uevents are for the major, low-frequent, global device state-changes,
>  not for carrying-out any sort of measurement data. Subsystems which
>  need that should use other facilities like poll()-able sysfs file or
>  any other subscription-based, client-tracking interface which does not
>  cause overhead if it isn't used. Uevents are not the right thing to
>  use here, and upstream udev should not paper-over broken kernel
>  subsystems."
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 94a403a..441272d 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -88,9 +88,6 @@ static void backlight_generate_event(struct backlight_device *bd,
>  	char *envp[2];
> 
>  	switch (reason) {
> -	case BACKLIGHT_UPDATE_SYSFS:
> -		envp[0] = "SOURCE=sysfs";
> -		break;
>  	case BACKLIGHT_UPDATE_HOTKEY:
>  		envp[0] = "SOURCE=hotkey";
>  		break;
> @@ -172,8 +169,6 @@ static ssize_t brightness_store(struct device *dev,
>  	}
>  	mutex_unlock(&bd->ops_lock);
> 
> -	backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);
> -
>  	return rc;
>  }
>  static DEVICE_ATTR_RW(brightness);
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index 53b7794..d2a27dd 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -29,7 +29,6 @@
> 
>  enum backlight_update_reason {
>  	BACKLIGHT_UPDATE_HOTKEY,
> -	BACKLIGHT_UPDATE_SYSFS,

+cc Henrique de Moraes Holschuh (Maintainer of thinkpad_acpi)

Hi Henrique de Moraes Holschuh,

'thinkpad_acpi.c' uses the 'BACKLIGHT_UPDATE_SYSFS'.
Henrique, can we remove it?

drivers/platform/x86/thinkpad_acpi.c
if (!rc && ibm_backlight_device)
                backlight_force_update(ibm_backlight_device,
                                        BACKLIGHT_UPDATE_SYSFS);

Best regards,
Jingoo Han

>  };
> 
>  enum backlight_type {

