Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3GYBNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:13:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30763 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GYBNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:13:44 -0400
X-AuditID: cbfee68e-b7f276d000002279-44-51f07bc60aa8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        "'Qing Xu'" <qingx@marvell.com>,
        "'Haojian Zhuang'" <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, holt@sgi.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <1374680547-5336-1-git-send-email-olof@lixom.net>
In-reply-to: <1374680547-5336-1-git-send-email-olof@lixom.net>
Subject: Re: [PATCH] mfd: max8925: fix dt code for backlight
Date: Thu, 25 Jul 2013 10:13:41 +0900
Message-id: <000401ce88d4$33773de0$9a65b9a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJzaoDSw9z/LVr2ed29jAuv8pmkhpgq0ZXA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+Zge6x6g+BBleb2C3mrF/DZnFhnblF
	/7QOVovLCy+xWmx6fA3I2jWHzeLU9c9sFs1XuC1273rKanG6m9WBy2PnrLvsHidm/GbxmHcy
	0GPzknqPKyeaWD0mL7zI7LFn/g9Wj74tqxg97l5/yeTxeZNcAFcUl01Kak5mWWqRvl0CV8ae
	w3tYClbLV1xddI6tgXGZZBcjJ4eEgIlE+7bLrBC2mMSFe+vZuhi5OIQEljFKrJ87iRmm6MiK
	o+wQiemMEtubFjFBOL8YJXY8fQBWxSagJvHly2F2EFtEwFti5qM1jCBFzAJdTBKdP6eAFQkJ
	2Eq0/25hBLE5BewkNvW9BWsQFrCR+LJpM9gdLAKqEsf2HgGzeQUsJeZc+cAIYQtK/Jh8jwXE
	ZhbQkli/8zgThC0vsXnNW6hTFSR2nH3NCHGEkcSCJy8ZIWpEJPa9eAd2kITAQg6Jpj2voZYJ
	SHybfAhoKAdQQlZi0wGoOZISB1fcYJnAKDELyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpRcZ
	6RUn5haX5qXrJefnbmKEJIK+HYw3D1gfYkwGWj+RWUo0OR+YSPJK4g2NzYwsTE1MjY3MLc1I
	E1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGhy5tP332Uyu7ctPa1yKGfhuswo
	zjUni+/yFCssEVzRe/4Esw8L056nfXac60T/X2ZL55FP85de/GhXe8Ku8ue3oqMnsuzeLr2e
	L/NOw8fARHOjnyvSdz9vruPkrp0aKJez+CLPSfvzRje79hy7O+lzu8dm+W3SLHZtsYl/nyjJ
	vVzoxapTmK3EUpyRaKjFXFScCADSd5fiGgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jQd1j1R8CDV7vZrSYs34Nm8WFdeYW
	/dM6WC0uL7zEarHp8TUga9ccNotT1z+zWTRf4bbYvespq8XpblYHLo+ds+6ye5yY8ZvFY97J
	QI/NS+o9rpxoYvWYvPAis8ee+T9YPfq2rGL0uHv9JZPH501yAVxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCnKimUJeaUAoUCEouLlfTtME0I
	DXHTtYBpjND1DQmC6zEyQAMJ6xgz9hzew1KwWr7i6qJzbA2MyyS7GDk5JARMJI6sOMoOYYtJ
	XLi3nq2LkYtDSGA6o8T2pkVMEM4vRokdTx8wg1SxCahJfPlyGKxDRMBbYuajNYwgRcwCXUwS
	nT+ngBUJCdhKtP9uYQSxOQXsJDb1vQVrEBawkfiyaTMriM0ioCpxbO8RMJtXwFJizpUPjBC2
	oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlhjhVQWLH2deMEEcYSSx48pIRokZEYt+Ld4wTGIVm
	IRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcJp5JrWDcWWDxSFG
	AQ5GJR7eFd/fBwqxJpYVV+YeYpTgYFYS4Y2t+BAoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKi
	yfnAFJhXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwG8e2i
	D8L+GSyq3zf/RuJlz0eBzHZNkUWreaOzDGoOsGTsErh6oX9qotaaSpPiv5s/1t+QPjg50qYm
	v3fb3dmMTb0hyvdPRb6Y8v7I0zcOzNukM54GSeSu5kn3mOlydkGOzu/oYxnHjx6vMn1mUTg9
	0fDemb1b/1k486pc27PsmE9H4ETnf3OVWIozEg21mIuKEwGSg3fTdwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 12:42 AM, Olof Johansson wrote:
> 
> The device-tree enablement for max8925 has several problems, but besides
> the bindings being wrong (and not having seen review) there's also some
> bad coding practices on how to fill in the platform_data from device tree.
> 
> I came across this since it causes a warning when compiling
> mmp2_defconfig, and instead of doing the minimal fix to silence the
> warning, I restructured the code a bit.
> 
> This silences the warning:
> drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
> drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]
> 
> Note that the bindings themselves need to be revisited too, but that will
> affect more than just the backlight driver and is best done separately;
> this just fixes the bad code for the backlight driver.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
> 
> Richard, Jingoo, this would be good to see go into 3.11 if you're
> comfortable with it.

CC'ed Andrew Morton


Hi Olof Johansson,

Currently, there is not git tree for Backlight subsystem.
I hope that this would go into 3.11 through one of other trees
with my Ack.

If not, it will go into 3.12-rc1 through mm-tree.

Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han

> 
> 
> -Olof
> 
>  drivers/video/backlight/max8925_bl.c |   41 +++++++++++++++++-----------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
> index 5ca11b0..886e797 100644
> --- a/drivers/video/backlight/max8925_bl.c
> +++ b/drivers/video/backlight/max8925_bl.c
> @@ -101,33 +101,37 @@ static const struct backlight_ops max8925_backlight_ops = {
>  	.get_brightness	= max8925_backlight_get_brightness,
>  };
> 
> -#ifdef CONFIG_OF
> -static int max8925_backlight_dt_init(struct platform_device *pdev,
> -			      struct max8925_backlight_pdata *pdata)
> +static void max8925_backlight_dt_init(struct platform_device *pdev)
>  {
>  	struct device_node *nproot = pdev->dev.parent->of_node, *np;
> -	int dual_string;
> +	struct max8925_backlight_pdata *pdata;
> +	u32 val;
> +
> +	if (!nproot || !IS_ENABLED(CONFIG_OF))
> +		return;
> +
> +	pdata = devm_kzalloc(&pdev->dev,
> +			     sizeof(struct max8925_backlight_pdata),
> +			     GFP_KERNEL);
> +	if (!pdata)
> +		return;
> 
> -	if (!nproot)
> -		return -ENODEV;
>  	np = of_find_node_by_name(nproot, "backlight");
>  	if (!np) {
>  		dev_err(&pdev->dev, "failed to find backlight node\n");
> -		return -ENODEV;
> +		return;
>  	}
> 
> -	of_property_read_u32(np, "maxim,max8925-dual-string", &dual_string);
> -	pdata->dual_string = dual_string;
> -	return 0;
> +	if (!of_property_read_u32(np, "maxim,max8925-dual-string", &val))
> +		pdata->dual_string = val;
> +
> +	pdev->dev.platform_data = pdata;
>  }
> -#else
> -#define max8925_backlight_dt_init(x, y)	(-1)
> -#endif
> 
>  static int max8925_backlight_probe(struct platform_device *pdev)
>  {
>  	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
> -	struct max8925_backlight_pdata *pdata = pdev->dev.platform_data;
> +	struct max8925_backlight_pdata *pdata;
>  	struct max8925_backlight_data *data;
>  	struct backlight_device *bl;
>  	struct backlight_properties props;
> @@ -170,13 +174,10 @@ static int max8925_backlight_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, bl);
> 
>  	value = 0;
> -	if (pdev->dev.parent->of_node && !pdata) {
> -		pdata = devm_kzalloc(&pdev->dev,
> -				     sizeof(struct max8925_backlight_pdata),
> -				     GFP_KERNEL);
> -		max8925_backlight_dt_init(pdev, pdata);
> -	}
> +	if (!pdev->dev.platform_data)
> +		max8925_backlight_dt_init(pdev);
> 
> +	pdata = pdev->dev.platform_data;
>  	if (pdata) {
>  		if (pdata->lxw_scl)
>  			value |= (1 << 7);
> --
> 1.7.10.4

