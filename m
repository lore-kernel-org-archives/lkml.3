Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3JXJ0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:26:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51868 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3JXJ0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:33 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-e4-5268e7c713ce
From: "hyunhee.kim" <hyunhee.kim@samsung.com>
To: "'Oliver Neukum'" <oneukum@suse.de>
Cc: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        broonie@opensource.wolfsonmicro.com, peter.ujfalusi@ti.com,
        wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kyungmin.park@samsung.com,
        "'Aristeu Sergio Rozanski Filho'" <aris@ruivo.org>
References: <000a01cec629$3cf34de0$b6d9e9a0$%kim@samsung.com>
 <20131021155558.GA4255@core.coreip.homeip.net>
 <025101ced083$35f2a270$a1d7e750$%kim@samsung.com>
 <1382603886.1559.11.camel@linux-fkkt.site>
In-reply-to: <1382603886.1559.11.camel@linux-fkkt.site>
Subject: RE: [PATCH v2] Input: add regulator haptic driver
Date: Thu, 24 Oct 2013 18:26:30 +0900
Message-id: <028401ced09b$1f6564d0$5e302e70$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7QlGzVSRYl8tohR/yeQB2ZNfsEyAABhYlw
Content-language: ko
X-OriginalArrivalTime: 24 Oct 2013 09:26:30.0069 (UTC)
 FILETIME=[1F1AEE50:01CED09B]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zXd3jzzOCDFrfMFrc/PSN1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW8W3aYvWA5T8WHuzINjK1cXYycHBICJhKrJ+1igrDF
	JC7cW8/WxcjFISSwjFHi/4w7bDBFX/YcYodITGeU+P7iNCtIQkhgHpPEqh3ZEIkVjBJftqxg
	AUmwCehKHP/9lxHEFhFQlfj16CYTSBGzwBomieb165kgOs4zSqx9Ox1sOaeAucS9tffAxgoL
	WEl8vXgGzGYB6n526AzYVF4BW4kzh16yQdiCEj8m3wOLMwuoS0yat4gZwtaWePLuAlAvB9Dd
	6hKP/upCHGEkMWX2LlaIEhGJfS/eMUJ8oCbx4elHFog3QyVmnzsLdpuEwDl2iV8nn7BB3CAg
	8W3yIRaImbISmw4wQ9RLShxccYNlAqP0LCQXzUJy0SwkF81CsnoBI8sqRtHUguSC4qT0IhO9
	4sTc4tK8dL3k/NxNjJB4nbCD8d4B60OMyUDrJzJLiSbnA+M9ryTe0NjMyMLUxNTYyNzSjDRh
	JXFetUdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYNQO4PecnRn7e//6zyL9TK5417lXp
	OT9p7sZ/7NsFQi04/vp9mZ4ayp+ZkLlq4TWO+bJqi1Md9jjZC0zbzmFnecropDf74Tu/l72/
	XMbo5jZdSJ1/4r6+D1eCP794NdVAqTaZ+5MFU9KbAHeXufrbdUMUeN5fPbCs0zVfzkDtXOp0
	dxm7H52MSizFGYmGWsxFxYkAxKhSC+0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQd1jzzOCDN5+t7a4+ekbq8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMeLfsMHvBcp6K
	D3dlGhhbuboYOTkkBEwkvuw5xA5hi0lcuLeerYuRi0NIYDqjxPcXp1lBEkIC85gkVu3Ihkis
	YJT4smUFC0iCTUBX4vjvv4wgtoiAqsSvRzeZQIqYBdYwSTSvX88E0XGeUWLt2+lMIFWcAuYS
	99beAxsrLGAl8fXiGTCbBaj72aEzYFN5BWwlzhx6yQZhC0r8mHwPLM4soC4xad4iZghbW+LJ
	uwtAvRxAd6tLPPqrC3GEkcSU2btYIUpEJPa9eMcI8YGaxIenH1kg3gyVmH3uLNMERtFZSDbM
	QrJhFpINs5CMWsDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOBk8k97BuKrB4hCjAAej
	Eg+vxof0ICHWxLLiytxDjBIczEoivJ4VGUFCvCmJlVWpRfnxRaU5qcWHGJOBATCRWUo0OR+Y
	qPJK4g2NTcyMLI3MjE3MjY1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgZF/6htlu6c2
	n/yTmH+saXPVcop1tn38WOSeT0GEIUNkCMPn5V9WBvCaRgnvueFyQHSdvoGpJqfWLdv+Wrvo
	9Z2/ohIDebinfd0fnyVdwtu8LeeSz8amZzuVuKzkT93MleL9N7vwde7MruO/WyVuCFX+KxdP
	s+r85dopvoa9W2e9BFPk+4jPSizFGYmGWsxFxYkA84TiMkoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Thanks for your review.
I resent patch v3 after removing wrong wrapping.

I made one toggle function because enable/disable functions have redundant codes and another reviewer suggested it.
Is it better to separate it into two functions?

Thanks,
Hyunhee Kim.

-----Original Message-----
From: Oliver Neukum [mailto:oneukum@suse.de] 
Sent: Thursday, October 24, 2013 5:38 PM
To: hyunhee.kim
Cc: 'Dmitry Torokhov'; broonie@opensource.wolfsonmicro.com; peter.ujfalusi@ti.com; wfp5p@virginia.edu; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; kyungmin.park@samsung.com; 'Aristeu Sergio Rozanski Filho'
Subject: Re: [PATCH v2] Input: add regulator haptic driver

On Thu, 2013-10-24 at 15:35 +0900, hyunhee.kim wrote:

Hi,

first of all your mail client mangled the patch.

> +static void regulator_haptic_toggle(struct regulator_haptic *haptic, bool
> enable)
> +{
> +	int ret;
> +
> +	mutex_lock(&haptic->mutex);
> +	if (enable && !haptic->enabled) {
> +		haptic->enabled = true;
> +		ret = regulator_enable(haptic->regulator);
> +		if (ret)
> +			dev_err(haptic->dev, "failed to enable
> regulator\n");
> +	} else if (!enable && haptic->enabled) {
> +		haptic->enabled = false;
> +		ret = regulator_disable(haptic->regulator);
> +		if (ret)
> +			dev_err(haptic->dev, "failed to disable
> regulator\n");
> +	}
> +	mutex_unlock(&haptic->mutex);
> +}
> +

Is there anything gained by the toggle parameter? Just code two
functions.

	Regards
		Oliver


