Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3I2Xhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:37:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62243 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3I2Xhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:37:40 -0400
X-AuditID: cbfee68e-b7f756d000004512-61-5248b9ba2a13
Message-id: <5248B9BA.9020003@samsung.com>
Date: Mon, 30 Sep 2013 08:37:30 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Get pdata from arizona structure not
 device
References: <1380378897-7164-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1380378897-7164-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkWHf3To8gg89vmS2mPnzCZvFvyg12
	i8u75rBZ3G5cwWax/O1/NgdWj02rOtk8Xk78zebRt2UVo8fnTXIBLFFcNimpOZllqUX6dglc
	Gfseb2Mt2M5XcXHVRZYGxufcXYycHBICJhJn2pcwQ9hiEhfurWfrYuTiEBJYyijxe+8ZRpii
	Hz/7wYqEBBYxSqx6IgxR9IpR4syVD2wgCV4BLYm5/bfZuxg5OFgEVCVOH1ACCbMBhfe/uAFW
	IioQJrFy+hUWiHJBiR+T74HZIgIWElOW3GIGaWUWKJX4sTQYJCwsECzxbmcPE8TaEImDs9ez
	gticAqESB+ZtAjuHWUBHYn/rNDYIW15i85q3UL/sYpdovxQGYrMICEh8m3yIBWS8hICsxKYD
	UCWSEgdX3GCZwCg2C8lBs5BMnYVk6gJG5lWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYgTF1
	+t+zvh2MNw9YH2JMBlo5kVlKNDkfGJN5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamAsVymPvzA3796qAxt6lLZpNV9eUX7xSskLH4GnRlMXRO/M
	9uaa/PvZuzVNX2y5X/+ekHRjXX7ov+PHP9l9T/+8hOf5//W/JjgWLNzCcGon77FTbYne7x8F
	Jjqmbf27796i5DPvUrK21pQdz0qSPC8XwseyXsjDKHo+Y1bIxumr122Vstz0hev6EyWW4oxE
	Qy3mouJEAJ9w7i+/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO6unR5BBue/WVhMffiEzeLflBvs
	Fpd3zWGzuN24gs1i+dv/bA6sHptWdbJ5vJz4m82jb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwlrGDP2Pd7GWrCdr+LiqossDYzPubsYOTkkBEwkfvzsZ4aw
	xSQu3FvPBmILCSxilFj1RLiLkQvIfsUocebKB7AEr4CWxNz+2+xdjBwcLAKqEqcPKIGE2YDC
	+1/cACsRFQiTWDn9CgtEuaDEj8n3wGwRAQuJKUtuMYO0MguUSvxYGgwSFhYIlni3s4cJYm2I
	xMHZ61lBbE6BUIkD8zaBncYsoCOxv3UaG4QtL7F5zVvmCYwCs5BsmIWkbBaSsgWMzKsYRVML
	kguKk9JzjfSKE3OLS/PS9ZLzczcxgmP2mfQOxlUNFocYBTgYlXh4LZZ6BAmxJpYVV+YeYpTg
	YFYS4V2eBBTiTUmsrEotyo8vKs1JLT7EmAz0/0RmKdHkfGA6ySuJNzQ2MTOyNDI3tDAyNidN
	WEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxuLJ+etr1gonX+0/VHkoPPlDoM6ElbYfAnQu
	iBU+PCbIeLrp++Skk1cE1Zg/6jm0yM9e17v7cVfy9e5HApm6WswHRT4586pxcgv9mLFp82KN
	89fMus4+Tni1zPXlxNMrZnEGGC72PSHlGB9jYvWM+dBciaNCO85N3HpAR2F21f05aR230p9w
	liqxFGckGmoxFxUnAgDGBuVEHQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2013 11:34 PM, Charles Keepax wrote:
> In the case of a device tree system there will be no pdata attached to
> the device, causing us to deference a NULL pointer. Better to take the
> pdata from the Arizona structure as this will always exist and we know
> will have been populated since it is populated by the MFD device which
> binds in the extcon driver.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index ec9a14e..178454d 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -1079,7 +1079,7 @@ static void arizona_micd_set_level(struct arizona *arizona, int index,
>  static int arizona_extcon_probe(struct platform_device *pdev)
>  {
>  	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
> -	struct arizona_pdata *pdata;
> +	struct arizona_pdata *pdata = &arizona->pdata;
>  	struct arizona_extcon_info *info;
>  	unsigned int val;
>  	int jack_irq_fall, jack_irq_rise;
> @@ -1088,8 +1088,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  	if (!arizona->dapm || !arizona->dapm->card)
>  		return -EPROBE_DEFER;
>  
> -	pdata = dev_get_platdata(arizona->dev);
> -
>  	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>  	if (!info) {
>  		dev_err(&pdev->dev, "Failed to allocate memory\n");
> 

No, extcon-arizona driver don't currently support DT to get platform data.
I cannot find some dt function to parse data from dts file.
You have to implement extcon-arizona driver by using DT binding style
to get platform data. I think this patch is not necessary.

Thanks
Chanwoo Choi





