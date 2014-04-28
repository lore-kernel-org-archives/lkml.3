Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaD1KaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:30:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50101 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbaD1KaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:30:06 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-26-535e2dace2bf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398677132-30600-1-git-send-email-gautam.vivek@samsung.com>
 <1398677132-30600-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1398677132-30600-2-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 1/4] usb: ohci-exynos: Use struct device instead of
 platform_device
Date: Mon, 28 Apr 2014 19:30:03 +0900
Message-id: <001801cf62cc$d1286690$737933b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9iw9nYX27eUdrQSqWm84Q4CF492wACNfkQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zse4a3bhgg5/fOS0O3q+3mH/kHKtF
	25WD7BbNi9ezWVxeeInV4sfrC2wWvQuusllsenyN1WJh2xIWi8u75rBZzDi/j8li0bJWZosJ
	vy+wOfB67J+7ht1j85J6j9l3fzB69G1Zxehx/MZ2Jo/Pm+QC2KK4bFJSczLLUov07RK4Mh6u
	8C54LFUxe9UxlgbGyWJdjJwcEgImEpdfX2GBsMUkLtxbz9bFyMUhJLCMUeJc921GmKINS54y
	QiQWMUp0vFzHDOH8ZpT4+P0kWBWbgJrEly+H2UFsEYFciVlvV4IVMQusYpJ4dfIqC0RHO6PE
	pP8TwDo4BTwlNj5fC9YhLBApcfTcO1YQm0VAVeLalkawOK+ArcT+wz1QtqDEj8n3wI5lFtCS
	WL/zOBOELS+xec1boG0cQLeqSzz6qwtxhJHE9ou/oUpEJPa9eAf2goTATA6Jm60dULsEJL5N
	PsQC0SsrsekAM8TLkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelFxnqFSfm
	Fpfmpesl5+duYoSkgN4djLcPWB9iTAZaP5FZSjQ5H5hC8kriDY3NjCxMTUyNjcwtzUgTVhLn
	TXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsbhCa6fD/COuH8X5OG4wut9k0X+hdPt4
	iZ/dV+vFr1X2Xvn5Y8Jn7ylHr79f4eT38lWSgMGc9L8yfVX2b4s/XH+S1aIvubw1KKzj65Wl
	PBvWpzy7rFOQeoWpa9bNmX0tItmPAzI5El/lhU48kZ6fPv1ctYBpzHF29oPRy23Ec2fZJwv8
	//yuSImlOCPRUIu5qDgRALlilygXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd01unHBBg8nsFgcvF9vMf/IOVaL
	tisH2S2aF69ns7i88BKrxY/XF9gsehdcZbPY9Pgaq8XCtiUsFpd3zWGzmHF+H5PFomWtzBYT
	fl9gc+D12D93DbvH5iX1HrPv/mD06NuyitHj+I3tTB6fN8kFsEU1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8x4uMK74LFUxexVx1gaGCeLdTFyckgImEhsWPKUEcIWk7hw
	bz1bFyMXh5DAIkaJjpfrmCGc34wSH7+fBKtiE1CT+PLlMDuILSKQKzHr7UqwImaBVUwSr05e
	ZYHoaGeUmPR/AlgHp4CnxMbna8E6hAUiJY6ee8cKYrMIqEpc29IIFucVsJXYf7gHyhaU+DH5
	HguIzSygJbF+53EmCFteYvOat0DbOIBuVZd49FcX4ggjie0Xf0OViEjse/GOcQKj0Cwkk2Yh
	mTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOMM+kdjCubLA4xCjAwajE
	wxsxJzZYiDWxrLgy9xCjBAezkgjvfom4YCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OBya/
	vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg1LvGk8KaFn1o
	2e9T97YmCrLlbM5JTJq3/2v60bUzlj5savC8f6E4Kc+g8mB8rqGdZOqn+TdPM9gVlYnccFXO
	f3yqoXlzyl6+T52NUWlf+87apy34fMMk7rrLR2axn8fzSuJmeuae+1mVcLl+W9LRmW/uvj/2
	zrvH5O/M6Hon5xem7rqGqZM/KLEUZyQaajEXFScCAEVRJnJ0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2014 6:25 PM, Vivek Gautam wrote:
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
>  drivers/usb/host/ohci-exynos.c |   20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 9cf80cb..05f00e3 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -39,18 +39,18 @@ struct exynos_ohci_hcd {
>  	struct usb_otg *otg;
>  };
> 
> -static void exynos_ohci_phy_enable(struct platform_device *pdev)
> +static void exynos_ohci_phy_enable(struct device *dev)
>  {
> -	struct usb_hcd *hcd = platform_get_drvdata(pdev);
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
>  	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
> 
>  	if (exynos_ohci->phy)
>  		usb_phy_init(exynos_ohci->phy);
>  }
> 
> -static void exynos_ohci_phy_disable(struct platform_device *pdev)
> +static void exynos_ohci_phy_disable(struct device *dev)
>  {
> -	struct usb_hcd *hcd = platform_get_drvdata(pdev);
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
>  	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
> 
>  	if (exynos_ohci->phy)
> @@ -139,7 +139,7 @@ skip_phy:
> 
>  	platform_set_drvdata(pdev, hcd);
> 
> -	exynos_ohci_phy_enable(pdev);
> +	exynos_ohci_phy_enable(&pdev->dev);
> 
>  	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
>  	if (err) {
> @@ -150,7 +150,7 @@ skip_phy:
>  	return 0;
> 
>  fail_add_hcd:
> -	exynos_ohci_phy_disable(pdev);
> +	exynos_ohci_phy_disable(&pdev->dev);
>  fail_io:
>  	clk_disable_unprepare(exynos_ohci->clk);
>  fail_clk:
> @@ -168,7 +168,7 @@ static int exynos_ohci_remove(struct platform_device *pdev)
>  	if (exynos_ohci->otg)
>  		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> 
> -	exynos_ohci_phy_disable(pdev);
> +	exynos_ohci_phy_disable(&pdev->dev);
> 
>  	clk_disable_unprepare(exynos_ohci->clk);
> 
> @@ -190,7 +190,6 @@ static int exynos_ohci_suspend(struct device *dev)
>  {
>  	struct usb_hcd *hcd = dev_get_drvdata(dev);
>  	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
> -	struct platform_device *pdev = to_platform_device(dev);
>  	bool do_wakeup = device_may_wakeup(dev);
>  	int rc = ohci_suspend(hcd, do_wakeup);
> 
> @@ -200,7 +199,7 @@ static int exynos_ohci_suspend(struct device *dev)
>  	if (exynos_ohci->otg)
>  		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> 
> -	exynos_ohci_phy_disable(pdev);
> +	exynos_ohci_phy_disable(dev);
> 
>  	clk_disable_unprepare(exynos_ohci->clk);
> 
> @@ -211,14 +210,13 @@ static int exynos_ohci_resume(struct device *dev)
>  {
>  	struct usb_hcd *hcd			= dev_get_drvdata(dev);
>  	struct exynos_ohci_hcd *exynos_ohci	= to_exynos_ohci(hcd);
> -	struct platform_device *pdev		= to_platform_device(dev);
> 
>  	clk_prepare_enable(exynos_ohci->clk);
> 
>  	if (exynos_ohci->otg)
>  		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> 
> -	exynos_ohci_phy_enable(pdev);
> +	exynos_ohci_phy_enable(dev);
> 
>  	ohci_resume(hcd, false);
> 
> --
> 1.7.10.4

