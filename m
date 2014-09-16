Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaIPXjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:39:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33533 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbaIPXjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:39:10 -0400
X-AuditID: cbfee690-f79ce6d00000115a-26-5418ca1cd635
Date: Tue, 16 Sep 2014 23:39:08 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: sm5502: Depend on I2C
To: Jean Delvare <jdelvare@suse.de>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140916233814787@myungjoo.ham
Msgkey: 20140916233814787@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140916233814787@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6256746.443221410910747510.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkSFfmlESIweSLPBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjyJkdzAXX2Cs+r3/A1sC4g72LkZNDSEBdYtGSk2wgtoSAicSi
	a/9ZIGwxiQv31gPFuYBqljJKbFu0lgmm6PPEI0wQiTmMEgcmPgKbxCKgKnHl3xGgbg4ONgE9
	iZmfk0HCwgJGEr0fToL1iggkSbRueMEEUsIsYCgx90MKxA1KEmv2vQLbyysgKHFy5hOoG1Ql
	Zi9cxg4RV5NoPjWTGSIuITFr+gVWCJtXYkb7U6h6OYlpX9dA1UhLnJ+1gRHml8XfH0PF+SWO
	3d4BdgJI75P7wTBjdm/+Ag0GAYmpZw4yQpRoSby5FAoR5pNYs/AtC8yUXaeWM8O03t8yF+xB
	ZgFFiSndD9khbC2JLz/2saH7ilfAUWLTv5/MExiVZyFJzULSPgtJO7KaBYwsqxhFUwuSC4qT
	0otM9IoTc4tL89L1kvNzNzECU8Lpf88m7GC8d8D6EKMAB6MSD6/HI/EQIdbEsuLK3EOMpsAo
	msgsJZqcD0w8eSXxhsZmRhamJqbGRuaWZkrivK+lfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYOyf/4FjvYf35PquBIv5RxxdvOYUGTyT2rFIVFrv9SM++zmPfvy40yYm6WEsfUFW8ltJ
	fZbX9qRa0XCvjAjd5wmZdk+YDs/JeHdzsbJ9/e5Z4lrPN9Vci39ef27JDq57LbZJ0XdNpq05
	13N21oUtL9c8cN7xIKxowzH7t8LFHE2fvnv1fNIVPajEUpyRaKjFXFScCADS0PQuBAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t/tPl2ZUxIhBlO2sVlc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIwj
	Z3YwF1xjr/i8/gFbA+MO9i5GTg4hAXWJRUtOsoHYEgImEp8nHmGCsMUkLtxbDxTnAqqZwyhx
	YOIjsAYWAVWJK/+OsHQxcnCwCehJzPycDBIWFjCS6P1wEqxXRCBJonXDCyaQEmYBQ4m5H1Ig
	VilJrNn3igXE5hUQlDg58wkLxCpVidkLl7FDxNUkmk/NZIaIS0jMmn6BFcLmlZjR/hSqXk5i
	2tc1UDXSEudnbWCEOXnx98dQcX6JY7d3gJ0A0vvkfjDMmN2bv0B9KyAx9cxBRogSLYk3l0Ih
	wnwSaxa+ZYGZsuvUcmaY1vtb5oI9yCygKDGl+yE7hK0l8eXHPjZ0X/EKOEps+veTeQKj3Cwk
	qVlI2mchaUdWs4CRZRWjaGpBckFxUnqFiV5xYm5xaV66XnJ+7iZGcGJ6tmQHY8MF60OMAhyM
	Sjy8Ho/EQ4RYE8uKK3MPMUpwMCuJ8P7wlQgR4k1JrKxKLcqPLyrNSS0+xGgKjL2JzFKiyfnA
	pJlXEm9obGxiZmJqaWJhYGquJM674FZSkJBAemJJanZqakFqEUwfEwenVANj83M2Xf/l+9O+
	/BGq81eyK3KtcahX8hSTi+FZ7C738XZnuOGLs24uaYcP3/80/RfTNOU1IkLPD4WH/tHumVdi
	MD1G0CXxy5fTb5ezVmp7OJU1C/dVdD9LSIy8WBpxtvzupVxBgfzHIhXVZdsqw2V3XPbeNXGa
	B3+c+7pGkek3hN3St0hmvVRiKc5INNRiLipOBAD7rMRfYgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8GNdH2A031309

> The SM5502 chip is an I2C device so its drivers must depend on I2C.
> Failing to do so results in build failures on kernels where I2C is
> not enabled.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/extcon/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -72,6 +72,7 @@ config EXTCON_PALMAS
>  
>  config EXTCON_SM5502
>  	tristate "SM5502 EXTCON support"
> +	depends on I2C
>  	select IRQ_DOMAIN
>  	select REGMAP_I2C
>  	select REGMAP_IRQ
> 
> -- 
> Jean Delvare
> SUSE L3 Support
> 
> 
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
