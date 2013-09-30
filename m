Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3I3XEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 19:04:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43527 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3I3XEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 19:04:10 -0400
X-AuditID: cbfee68e-b7f756d000004512-f3-524a03697255
Message-id: <524A0369.1080101@samsung.com>
Date: Tue, 01 Oct 2013 08:04:09 +0900
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
 <5248B9BA.9020003@samsung.com>
 <20130930095202.GY3635@opensource.wolfsonmicro.com>
In-reply-to: <20130930095202.GY3635@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkUDeT2SvI4O8MHoupD5+wWfybcoPd
	4vKuOWwWtxtXsFksf/ufzYHVY9OqTjaPlxN/s3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJX
	Ruv8ScwFy4Qqnmw5zdTA+JKvi5GTQ0LAROLNtmXsELaYxIV769m6GLk4hASWMkr0L9zKDlN0
	/cRmFojEdEaJ1llLoZxXjBK/Zl8Hcjg4eAW0JE5cEQFpYBFQlWi7/YAVxGYDCu9/cYMNxBYV
	CJNYOf0KC4jNKyAo8WPyPTBbRMBCYsqSW8wgY5gFSiV+LA0GCQsLBEu829nDBLFqNaPE1NON
	jCAJTgEHiXePb4L1MgvoSOxvncYGYctLbF7zlhmkQUJgF7vEs+0L2SEOEpD4NvkQ2J0SArIS
	mw4wQzwmKXFwxQ2WCYxis5CcNAvJ2FlIxi5gZF7FKJpakFxQnJReZKRXnJhbXJqXrpecn7uJ
	ERhZp/8969vBePOA9SHGZKCVE5mlRJPzgZGZVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQZGHpdL2//vfPhxyYY33e/0Tgo83LDv7+LNi925Tq23
	ff/KW9FVQmjXAnW3adHCmxUd8i87vev2DzroYpr/98uZrEimp+8PpWwTeeffc/zNiZVLE249
	PLzyl7jUkWtOeybUPC4r+vRrQlKWYB7vo79XKrsOOmSbLdP9e/DisQfPo0vyfz85dnQtw2sl
	luKMREMt5qLiRACGkH9hwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoG4ms1eQQcNaFoupD5+wWfybcoPd
	4vKuOWwWtxtXsFksf/ufzYHVY9OqTjaPlxN/s3n0bVnF6PF5k1wAS1QDo01GamJKapFCal5y
	fkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0GIlhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY0br/EnMBcuEKp5sOc3UwPiSr4uRk0NCwETi+onNLBC2
	mMSFe+vZuhi5OIQEpjNKtM5aygLhvGKU+DX7OpDDwcEroCVx4ooISAOLgKpE2+0HrCA2G1B4
	/4sbbCC2qECYxMrpV8CG8goISvyYfA/MFhGwkJiy5BYzyBhmgVKJH0uDQcLCAsES73b2MEGs
	Ws0oMfV0IyNIglPAQeLd45tgvcwCOhL7W6exQdjyEpvXvGWewCgwC8mKWUjKZiEpW8DIvIpR
	NLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOG6fSe9gXNVgcYhRgINRiYfXoN4zSIg1say4MvcQ
	owQHs5II7+blQCHelMTKqtSi/Pii0pzU4kOMycAQmMgsJZqcD0wpeSXxhsYmZkaWRuaGFkbG
	5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAOI+LvbhV1y54YnPX1BCZcs0p7c1a/b/W
	dLdtWX/6jeZ75uQv1scDetUl4v0qb8v83PSPz7xoYf9yKe8qjT6mjY8DfvdsOVDwLfW+u++G
	fctNjHa3PwiYaMlutzAn7MIdi9UsU46+PmLE1lvcFLd1wvv2VMZphs7Z8WdWe9YqzJn42sf4
	483nSizFGYmGWsxFxYkAFbWS0x8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 06:52 PM, Charles Keepax wrote:
> On Mon, Sep 30, 2013 at 08:37:30AM +0900, Chanwoo Choi wrote:
>> No, extcon-arizona driver don't currently support DT to get platform data.
>> I cannot find some dt function to parse data from dts file.
>> You have to implement extcon-arizona driver by using DT binding style
>> to get platform data. I think this patch is not necessary.
> 
> Currently the Arizona MFD driver reads the device tree
> information and populates the pdata structure, this happens in
> drivers/mfd/arizona-core.c. Then the various drivers just use the
> pdata as normal.
> 
> Admittedly, at the moment we don't parse any data for the extcon
> driver but without this patch we will attempt to use a NULL
> pointer on device tree systems.
> 
> I would also be happy to implement this as a NULL check on the
> pdata when we use it if that is preferable? But since we have the
> cached pdata seems we might as well use it.
> 

I find below pdata list for extcon-arizona driver.
But, drivers/mfd/arizona-core.c don't parse dt data for below pdata list
of extcon-arizona. Did you test this patch for extcon-arizona operation?

arizona->pdata.micd_pol_gpio
arizona->pdata.micd_force_micbias	
arizona->pdata.hpdet_id_gpio
arizona->pdata.hpdet_acc_id
arizona->pdata.hpdet_acc_id_line
arizona->pdata.micd_detect_debounce
arizona->pdata.jd_gpio5
arizona->pdata.micd_timeout
arizona->pdata.num_micd_configs
arizona->pdata.micd_configs
arizona->pdata.micd_bias_start_time
arizona->pdata.micd_rate
arizona->pdata.micd_dbtime
arizona->pdata.num_micd_ranges
...

If you fix NULL pointer error about pdata,
I think only that extcon-arizona modify it as following:

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index e557130..3429906 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1088,6 +1088,10 @@ static int arizona_extcon_probe(struct platform_device *pdev)
                return -EPROBE_DEFER;
 
        pdata = dev_get_platdata(arizona->dev);
+       if (!pdata) {
+               dev_err(&pdev->dev, "Failed to get platform data\n");
+               return -EINVAL;
+       }
 
        info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
        if (!info) {

Thanks,
Chanwoo Choi
