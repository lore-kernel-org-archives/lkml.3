Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3COAar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:30:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55651 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3COAao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:30:44 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-19-51426bb22245
Date: Fri, 15 Mar 2013 00:30:42 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] usb: ehci-s5p: Use devm for requesting ehci_vbus_gpio
To: Doug Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>
Cc: Alexander Graf <agraf@suse.de>, Vivek Gautam <gautam.vivek@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130315002942126@jg1.han
Msgkey: 20130315002942126@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130315002942126@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29811710.141161363307438813.JavaMail.weblogic@epv6ml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zQ91N2U6BBh8WGVpc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMeHb6I3PBDtGKpZ9OMDYwvhHpYuTkEBJQkph0ci8jiC0hYCIxt7uX
	CcIWk7hwbz0bRM0yRonG95owNfvXdzBDxOczSixuLAGxWQRUJR7/vgpWzyagLjHhdzMLiC0s
	4CXR1TkVzBYR8JE4ufw0UC8XB7PAGmaJTxPmskIMkpW4N3k22FBeAUGJkzOfsEAsU5B4fWkz
	E0RcUWLDzglsEHEJiTv397NC2LwSM9qfQtXLSUz7uoYZwpaWOD9rAyPMM4u/P4aK80scu70D
	aCYHWO+T+8EwY3Zv/gI1XkBi6pmDUK2qEptuT4FaxSexZuFbqFWCEqevdTPD9DZs/M0OYjMD
	nTml+yGUrSXx5cc+NnRv8Qq4SNxbsYRxAqPyLCSpWUjaZyFpR1azgJFlFaNoakFyQXFSepEp
	cmRvYoSkwYk7GO8fsD7EuJ8RGCkTmaVEk/OBiTSvJN7Q2MzIwtTE1NjI3NKMQmETUwsLEyOq
	CCuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYMzgM3hmP2Xvru+n7r3V3f28t7jw
	h+aJwy5bxBb9Z7+S+G1D1FsV/zCmZYkLfuc0Td7itWhr0rd7M0sMdy+s06/d+CxVIJXDTyBV
	razL6XIDb/ferfvNZK5neXCUfNlkrXZ9Rf9yK+uXJ3/vUkmx2/ThREHE/27lX+ta4g2L5Fcm
	nOD/sjqw544SS3FGoqEWc1FxIgDO/Vd69gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2dN1N2U6BBm2NihaXd81hc2D0+LxJ
	LoAxKsMmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2io
	kkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKdrIwFjPyNREz8jYQM/YMtbK0MDAyBSoKiEj
	49npj8wFO0Qrln46wdjA+Eaki5GTQ0hASWLSyb2MILaEgInE/vUdzBC2mMSFe+vZIGrmM0os
	biwBsVkEVCUe/74KFmcTUJeY8LuZBcQWFvCS6OqcCmaLCPhInFx+GmgOFwezwBpmiU8T5rJC
	DJKVuDd5NtgCXgFBiZMzn7BALFOQeH1pMxNEXFFiw84JbBBxCYk79/ezQti8EjPan0LVy0lM
	+7oG6lBpifOzNjDCHL34+2OoOL/Esds7gGZygPU+uR8MM2b35i9Q4wUkpp45CNWqKrHp9hSo
	VXwSaxa+hVolKHH6WjczTG/Dxt/sIDYz0JlTuh9C2VoSX37sY0P3Fq+Ai8S9FUsYJzDKzUKS
	moWkfRaSdmQ1CxhZVjGKphYkFxQnpVcY6xUn5haX5qXrJefnbmIEp6hni3cw/j9vfYhRgINR
	iYfX4aFjoBBrYllxZe4hRgkOZiUR3l1/gUK8KYmVValF+fFFpTmpxYcYk4ExOJFZSjQ5H5g+
	80riDY2NTcxMTM0NLAwszUkTVhLnfdZqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUS1HuTiU+d+b
	O2cYj549tvD2u7yaYoWV7id+st9RdJrz9MxbgdhDr9f5qhsoC3FGzjvlc9o/am3uvPudQcfY
	zzw7FfbyeI3NxfjFfcYX+oqu9D6oEl6p/aPf3l/qT4VYXll95Or+vQ7cKi/0tNTFfl1expFc
	5v9cqLT8qsSMDdMdwyeoLiyKV2Ipzkg01GIuKk4EAGKTyQiVAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2F0UouZ001560

On Wednesday, March 13, 2013 4:03 AM, Doug Anderson wrote:
> 
> The ehci_vbus_gpio is requested but never freed.  This can cause
> problems with deferred probes and would cause problems if
> s5p_ehci_remove was ever called.  Use devm to fix this.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/usb/host/ehci-s5p.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 20ebf6a..a464197 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -92,6 +92,7 @@ static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
> 
>  static void s5p_setup_vbus_gpio(struct platform_device *pdev)
>  {
> +	struct device *dev = &pdev->dev;

Hi Doug Anderson,

Would you replace other '&pdev->dev' with 'dev' in s5p_setup_vbus_gpio()
as below? It seems to be better for readability.

-       gpio = of_get_named_gpio(pdev->dev.of_node,
+       gpio = of_get_named_gpio(dev->of_node,
                        "samsung,vbus-gpio", 0);
        if (!gpio_is_valid(gpio))
                return;

-       err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
+       err = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_HIGH,
+                               "ehci_vbus_gpio");
        if (err)
-               dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
+               dev_err(dev, "can't request ehci vbus gpio %d", gpio);


Best regards,
Jingoo Han

>  	int err;
>  	int gpio;
> 
> @@ -103,7 +104,8 @@ static void s5p_setup_vbus_gpio(struct platform_device *pdev)
>  	if (!gpio_is_valid(gpio))
>  		return;
> 
> -	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
> +	err = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_HIGH,
> +				    "ehci_vbus_gpio");
>  	if (err)
>  		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
>  }
> --
> 1.8.1.3
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
