Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaE3BS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:18:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58179 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbaE3BSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:18:25 -0400
X-AuditID: cbfee68f-b7fef6d000003970-dc-5387dc5efa25
Message-id: <5387DC5E.7010907@samsung.com>
Date: Fri, 30 May 2014 10:18:22 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] extcon: arizona: Remove duplicate set of input parent
 device
References: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkWDfuTnuwwbotRhb/ptxgt7i8aw6b
	xe3GFWwWy9/+Z3Ng8Xg58TebR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGW8exFXMFGg4uPb
	02wNjF28XYycHBICJhLLjz9jgbDFJC7cW8/WxcjFISSwlFFi/qxzrHBFV/YxQySmM0qcPLUO
	quo1o8SfnWvAqngFtCRaz/ewgdgsAqoS3y88YAex2YDi+1/cAIuLCoRJrJx+hQWiXlDix+R7
	YLaIgIXElCW3mEFsZoFEiTnnvoD1CguESxzr2Qc2X0ggVOLri4dgNifQnPu/V7BA1OtI7G+d
	xgZhy0tsXvMW7FIJgUXsEguPLGCHOEhA4tvkQ0ANHEAJWYlNB5ghPpOUOLjiBssERrFZSE6a
	hWTsLCRjFzAyr2IUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjKLT/57172C8e8D6EGMy0MqJ
	zFKiyfnAKMwriTc0NjOyMDUxNTYytzQjTVhJnPf+w6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYxcWQGzY1UP+q8WvXqj2uRU+ZzVwW3/vid13Pr3ZpPkCVF+AbYr8+et6F1mqv7gZnbv
	FLlklWtWuw8IvmUT+ZXx6aTfpcV+Jx52VqiEer+0DDJxerQtO0rXhk/GIjDS+UjCzpiQGs2O
	CT/UChg+h51Q79o3fb6Pcteuhk129QkXp7ap/tL8MVeJpTgj0VCLuag4EQAbDHUYuAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoG7cnfZgg6U/tCz+TbnBbnF51xw2
	i9uNK9gslr/9z+bA4vFy4m82j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMePcirmCiQMXHt6fZGhi7eLsYOTkkBEwkll/Zxwxhi0lcuLeerYuRi0NI
	YDqjxMlT66Cc14wSf3auYQWp4hXQkmg938MGYrMIqEp8v/CAHcRmA4rvf3EDLC4qECaxcvoV
	Foh6QYkfk++B2SICFhJTltwC28YskCgx59wXsF5hgXCJYz37wOYLCYRKfH3xEMzmBJpz//cK
	Foh6HYn9rdPYIGx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeu
	l5yfu4kRHKPPpHYwrmywOMQowMGoxMPbGNkeLMSaWFZcmXuIUYKDWUmE1/EwUIg3JbGyKrUo
	P76oNCe1+BBjMjAEJjJLiSbnA9NHXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNT
	UwtSi2C2MHFwSjUwnrtyvyywl2OHS9altUbdje4XumI6GGJsLn4OnnaRu+34k66FspEdz+73
	Pgp8tdtMu2Ppt8dNBRELI3Ym3im99Kvg9+8rmrcVF5l3/dzT+2DniliWY245Xhu15wVOstl/
	6OFzrqmbHr7t7y2wOr3VaF08l5Ja+xsL259PVarsV82uSfVw0C2KUWIpzkg01GIuKk4EAFCl
	q2oVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 05/30/2014 12:27 AM, Charles Keepax wrote:
> devm_input_allocate_device already sets the parent device to be that
> passed to it, we also set this manually in arizona_extcon_probe. This
> patch removes the redundant set from arizona_extcon_probe.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index cf90743..21ee055 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -1186,7 +1186,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  
>  	info->input->name = "Headset";
>  	info->input->phys = "arizona/extcon";
> -	info->input->dev.parent = &pdev->dev;
>  
>  	if (pdata->num_micd_configs) {
>  		info->micd_modes = pdata->micd_configs;
> 

After checked this patch, I'm going to modify devm_extcon_dev_allocate()
to set parent device for extcon device as following patch.

Thanks,
Chanwoo Choi

commit b8ca2d99209e402faf12545759c8ed14fa3455a0
Author: Chanwoo Choi <cw00.choi@samsung.com>
Date:   Fri May 30 10:13:15 2014 +0900

    extcon: Set parent device of extcon device using prameter of devm_extcon_dev_allocate
    
    This patch set the parent device of extcon device using first parameter of
    devm_extco_dev_allocate() to remove duplicate code on all of extcon provider
    drivers.
    
    Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
    Reported-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 18d42c0..4c2f2c5 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -645,6 +645,8 @@ struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
                return edev;
        }
 
+       edev->dev.parent = dev;
+
        *ptr = edev;
        devres_add(dev, ptr);

