Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaD1Kaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:30:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61939 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbaD1Kag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:30:36 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-0b-535e2dcab839
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398677132-30600-1-git-send-email-gautam.vivek@samsung.com>
 <1398677132-30600-3-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1398677132-30600-3-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 2/4] usb: ehci-exynos: Use struct device instead of
 platform_device
Date: Mon, 28 Apr 2014 19:30:34 +0900
Message-id: <001901cf62cc$e32a3bc0$a97eb340$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9iw9w6YhzHZgLWRU6+r8z+O0+mMQACPeWA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zke4p3bhgg4NHRC0O3q+3mH/kHKtF
	25WD7BbNi9ezWVxeeInV4sfrC2wWvQuusllsenyN1WJh2xIWi8u75rBZzDi/j8li0bJWZosJ
	vy+wOfB67J+7ht1j85J6j9l3fzB69G1Zxehx/MZ2Jo/Pm+QC2KK4bFJSczLLUov07RK4MrZe
	n8lesJur4tP9+0wNjMc5uhg5OSQETCSWzXvIBmGLSVy4tx7I5uIQEljGKPH6yDYWmKIpOx8w
	QSSmM0pcvn+TBcL5zSix6ewssCo2ATWJL18Os4PYIgK5ErPermQGKWIWWMUk8erkVaiOdkaJ
	Pe3rmECqOAU8Jf62zwNbLiwQKXG1fRoziM0ioCpxeuptVhCbV8BW4vb+B1C2oMSPyffAtjEL
	aEms33mcCcKWl9i85i1QLwfQreoSj/7qQhxhJPH/UTNUuYjEvhfvGEFukBCYyyFx+sE2dohd
	AhLfJh9igeiVldh0gBniZUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM
	9IoTc4tL89L1kvNzNzFCkkDfDsabB6wPMSYDrZ/ILCWanA9MInkl8YbGZkYWpiamxkbmlmak
	CSuJ8y56mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZG9esfsB4fmhCa+/P7zQvoq7+dn
	Nt+3dFzMFr4g0iryVcD6H7buzm4PmIW+XbRYc9GzsCzg8um+xPDLkQ+2FQsr80142v3jzJT4
	t2/3P0kyTN73+5n8dCfnuKooa8X++J2bhf1majmU7ZOIClrV6M3mPSUylifMuef/fZUF8TEZ
	RacMUlLv3VNiKc5INNRiLipOBAD8TiojGAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jQd1TunHBBscmC1ocvF9vMf/IOVaL
	tisH2S2aF69ns7i88BKrxY/XF9gsehdcZbPY9Pgaq8XCtiUsFpd3zWGzmHF+H5PFomWtzBYT
	fl9gc+D12D93DbvH5iX1HrPv/mD06NuyitHj+I3tTB6fN8kFsEU1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8zYen0me8FuropP9+8zNTAe5+hi5OSQEDCRmLLzAROELSZx
	4d56ti5GLg4hgemMEpfv32SBcH4zSmw6O4sFpIpNQE3iy5fD7CC2iECuxKy3K5lBipgFVjFJ
	vDp5FaqjnVFiT/s6sLmcAp4Sf9vnsYHYwgKRElfbpzGD2CwCqhKnp95mBbF5BWwlbu9/AGUL
	SvyYfA9sG7OAlsT6nceZIGx5ic1r3gL1cgDdqi7x6K8uxBFGEv8fNUOVi0jse/GOcQKj0Cwk
	k2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOMc+kdjCubLA4xCjA
	wajEwxsxJzZYiDWxrLgy9xCjBAezkgjvfom4YCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3O
	B6a/vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgTL6v619j
	r+K+OfbhFFY5L9s9bxqfrg3+dVUvX+fy+bIjbZtfnGbqVjrw/8KR+BMMip4F++56LlFmj9kl
	fCyG6XHTmhaPiaKPG3z+bd2bzOHPKtZX+JPvw+SrZj6+jA+2cnbrvX3GvOhdzsFb+jP+vJ/V
	8Mb4tlG32cdJN8U5PCL8mao+t/NuUWIpzkg01GIuKk4EAOEPN651AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2014 6:26 PM, Vivek Gautam wrote:
> 
> Change to use struct device instead of struct platform_device
> for some static functions.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/host/ehci-exynos.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index 7f425ac..4d763dc 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -50,9 +50,8 @@ struct exynos_ehci_hcd {
> 
>  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
> 
> -static void exynos_setup_vbus_gpio(struct platform_device *pdev)
> +static void exynos_setup_vbus_gpio(struct device *dev)
>  {
> -	struct device *dev = &pdev->dev;
>  	int err;
>  	int gpio;
> 
> @@ -88,7 +87,7 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>  	if (err)
>  		return err;
> 
> -	exynos_setup_vbus_gpio(pdev);
> +	exynos_setup_vbus_gpio(&pdev->dev);
> 
>  	hcd = usb_create_hcd(&exynos_ehci_hc_driver,
>  			     &pdev->dev, dev_name(&pdev->dev));
> --
> 1.7.10.4

