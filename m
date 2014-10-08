Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaJHDKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:10:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25181 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaJHDKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:10:50 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ab6d0000046f7-7a-5434ab374382
Content-transfer-encoding: 8BIT
Message-id: <5434AB37.1080603@samsung.com>
Date: Wed, 08 Oct 2014 12:10:47 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Paul <seanpaul@google.com>, kishon <kishon@ti.com>,
        ajaykumar.rs@samsung.com, Jingoo Han <jg1.han@samsung.com>,
        cpgs@samsung.com
Subject: Re: [PATCH 2/3] drm/exynos: dp: Remove support for unused dptx-phy
References: <1410786785-9838-1-git-send-email-gautam.vivek@samsung.com>
 <1410786785-9838-3-git-send-email-gautam.vivek@samsung.com>
 <CAFp+6iGaZR+4YQLXe+c2EZ9RwUpX73jr4H_KWyFOvxPWbpAyew@mail.gmail.com>
In-reply-to: <CAFp+6iGaZR+4YQLXe+c2EZ9RwUpX73jr4H_KWyFOvxPWbpAyew@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkQNd8tUmIwfyD2hYH3h9ksXh5SNNi
	/pFzrBZXvr5ns2i7cpDd4vLCS6wWF572sFlc3jWHzWLG+X1MFnMP5jpweSzYVOpxv/s4k0ff
	llWMHsdvbGfy+LxJLoA1issmJTUnsyy1SN8ugSvj29+nTAVTVCs+911ibmDcINnFyMkhIWAi
	0f5hEyOELSZx4d56ti5GLg4hgaWMEnPOX2WFKfrcc4kRIrGIUeJeQyc7SIJXQFDix+R7LF2M
	HBzMAvISRy5lg4SZBdQlJs1bxAxR/4pR4vGF36wQ9VoS995/A6tnEVCVeHDCEiTMBmROXHGf
	DcQWFQiTePFqFzOILSKgLbF97iRWkDnMAt+ZJLZePMII0iss4C3x4h4fxPwzjBJTp95hAmng
	FAgGmvkT7FAJgUfsEsvf94JNZREQkPg2+RDYYgkBWYlNB5ghHpOUOLjiBssERrFZSN6ZhfDO
	LCTvLGBkXsUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGI2n/z2bsIPx3gHrQ4wCHIxKPLwG
	zSYhQqyJZcWVuYcYTYGOmMgsJZqcD4z5vJJ4Q2MzIwtTE1NjI3NLMyVx3tdSP4OFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MBZOXXmTU+jZv5AF15ds3Tun7GSlqPQBiWn+9jcTMtXc9W34
	fHi9T/xSslv8Plp8+z5jpgkPH6hIxOd4LE15phplpNcx8+uh/TeOMs+c1MWgfjviAAu346JQ
	lRjFQ7op9063bCjyMpgVvCLG/PzNOrl1Tju2+6/7snnBu5Kv8hE+RYeXnsxZWajEUpyRaKjF
	XFScCAA1YrhawQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAV3z1SYhBpM/KVoceH+QxeLlIU2L
	+UfOsVpc+fqezaLtykF2i8sLL7FaXHjaw2ZxedccNosZ5/cxWcw9mOvA5bFgU6nH/e7jTB59
	W1Yxehy/sZ3J4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGd/+
	PmUqmKJa8bnvEnMD4wbJLkZODgkBE4nPPZcYIWwxiQv31rN1MXJxCAksYpS419DJDpLgFRCU
	+DH5HksXIwcHs4C8xJFL2SBhZgF1iUnzFjFD1L9ilHh84TcrRL2WxL3338DqWQRUJR6csAQJ
	swGZE1fcZwOxRQXCJF682sUMYosIaEtsnzuJFWQOs8B3JomtF48wgvQKC3hLvLjHBzH/DKPE
	1Kl3mEAaOAWCgWb+ZJzAKDALyXmzEM6bheS8BYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGCY/2Z1A7GlQ0WhxgFOBiVeHgNmk1ChFgTy4orcw8xSnAwK4nwRkYDhXhTEiurUovy44tK
	c1KLDzGaAj03kVlKNDkfmIbySuINjU3MjCyNzA0tjIzNlcR5D7RaBwoJpCeWpGanphakFsH0
	MXFwSjUwznqYeXFq4b+U7vX28/Zc2PLjY4iW9CeOHw2qXZYbXJ1/Pjt3ZrvzkrZz5YdOO1d1
	mm35OWlX6EXh62u4nb4e/3Oz9H3LRe9TEVXMtUsCRIsTPGe8KbrQfffbrleznsdWpe6+ZyjR
	032ivbww/s66l0eidrUkTZUzDRW5Yb+KKUt87YKa6Q7me5VYijMSDbWYi4oTAdYDoMoLAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 10월 08일 11:57, Vivek Gautam wrote:
> Hi,
> 
> 
> On Mon, Sep 15, 2014 at 6:43 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> Now that we have moved to generic phy based bindings,
>> we don't need to have any code related to older dptx-phy.
>> Nobody is using this dptx-phy anymore, so removing the
>> same.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> ---
> 
> Is someone taking care of this patch ? We already have got the corresponsding
> dp-phy patch merged, so we should also get this patch in.
> 

Can anyone give me tested-by after test? I cannot test this module
because I have no any board equipped with dp panel.

Jingoo or other?

Thanks,
Inki Dae

>>  drivers/gpu/drm/exynos/exynos_dp_core.c |   58 +++++++------------------------
>>  drivers/gpu/drm/exynos/exynos_dp_core.h |    2 --
>>  2 files changed, 13 insertions(+), 47 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
>> index 4f3c7eb..5ffc1b2 100644
>> --- a/drivers/gpu/drm/exynos/exynos_dp_core.c
>> +++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
>> @@ -1050,28 +1050,14 @@ static int exynos_dp_create_connector(struct exynos_drm_display *display,
>>
>>  static void exynos_dp_phy_init(struct exynos_dp_device *dp)
>>  {
>> -       if (dp->phy) {
>> +       if (dp->phy)
>>                 phy_power_on(dp->phy);
>> -       } else if (dp->phy_addr) {
>> -               u32 reg;
>> -
>> -               reg = __raw_readl(dp->phy_addr);
>> -               reg |= dp->enable_mask;
>> -               __raw_writel(reg, dp->phy_addr);
>> -       }
>>  }
>>
>>  static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
>>  {
>> -       if (dp->phy) {
>> +       if (dp->phy)
>>                 phy_power_off(dp->phy);
>> -       } else if (dp->phy_addr) {
>> -               u32 reg;
>> -
>> -               reg = __raw_readl(dp->phy_addr);
>> -               reg &= ~(dp->enable_mask);
>> -               __raw_writel(reg, dp->phy_addr);
>> -       }
>>  }
>>
>>  static void exynos_dp_poweron(struct exynos_drm_display *display)
>> @@ -1210,39 +1196,21 @@ static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
>>
>>  static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
>>  {
>> -       struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
>> -       u32 phy_base;
>>         int ret = 0;
>>
>> -       dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
>> -       if (!dp_phy_node) {
>> -               dp->phy = devm_phy_get(dp->dev, "dp");
>> -               return PTR_ERR_OR_ZERO(dp->phy);
>> -       }
>> -
>> -       if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
>> -               dev_err(dp->dev, "failed to get reg for dptx-phy\n");
>> -               ret = -EINVAL;
>> -               goto err;
>> -       }
>> -
>> -       if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
>> -                               &dp->enable_mask)) {
>> -               dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
>> -               ret = -EINVAL;
>> -               goto err;
>> -       }
>> -
>> -       dp->phy_addr = ioremap(phy_base, SZ_4);
>> -       if (!dp->phy_addr) {
>> -               dev_err(dp->dev, "failed to ioremap dp-phy\n");
>> -               ret = -ENOMEM;
>> -               goto err;
>> +       dp->phy = devm_phy_get(dp->dev, "dp");
>> +       if (IS_ERR(dp->phy)) {
>> +               ret = PTR_ERR(dp->phy);
>> +               if (ret == -ENOSYS || ret == -ENODEV) {
>> +                       dp->phy = NULL;
>> +               } else if (ret == -EPROBE_DEFER) {
>> +                       return ret;
>> +               } else {
>> +                       dev_err(dp->dev, "no DP phy configured\n");
>> +                       return ret;
>> +               }
>>         }
>>
>> -err:
>> -       of_node_put(dp_phy_node);
>> -
>>         return ret;
>>  }
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.h b/drivers/gpu/drm/exynos/exynos_dp_core.h
>> index a1aee69..6426201 100644
>> --- a/drivers/gpu/drm/exynos/exynos_dp_core.h
>> +++ b/drivers/gpu/drm/exynos/exynos_dp_core.h
>> @@ -153,8 +153,6 @@ struct exynos_dp_device {
>>         struct clk              *clock;
>>         unsigned int            irq;
>>         void __iomem            *reg_base;
>> -       void __iomem            *phy_addr;
>> -       unsigned int            enable_mask;
>>
>>         struct video_info       *video_info;
>>         struct link_train       link_train;
>> --
>> 1.7.10.4
>>
> 
> 
> 

