Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaHMHk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:40:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65154 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMHky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:40:54 -0400
X-AuditID: cbfee691-b7f306d000003d81-b0-53eb16810457
Message-id: <53EB1681.9040602@samsung.com>
Date: Wed, 13 Aug 2014 16:40:49 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next] extcon: fix extcon-sm5502 build when CONFIG_I2C=m
References: <53EB122E.3050407@infradead.org>
In-reply-to: <53EB122E.3050407@infradead.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkRLdR7HWwwafpOhaXd81hszi4sI3R
	4nbjCjaLt3emsziweGxeoeXRt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGYcWNbMUTBSu2HHU
	rIHxjEAXIyeHhICJxNoZ59khbDGJC/fWs3UxcnEICSxllPi58Q4jTNHF6e1MEIlFjBJHnu+A
	qnrNKPHw/gywdl4BLYm/D7uYQGwWAVWJp7+ns4DYbEDx/S9usIHYogJhEiunX2GBqBeU+DH5
	HpgtIqAh8fvKFVaQocwC/YwS5ydNAVstLOAjcevnabBmIQEdiQNH17OC2JwCuhJnl74FizMD
	xfe3ToOy5SU2r3nLDDJIQmARu8S6nT8ZIS4SkPg2+RDQNg6ghKzEpgPMEK9JShxccYNlAqPY
	LCQ3zUIydhaSsQsYmVcxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBEbR6X/PJu5gvH/A+hBj
	MtDKicxSosn5wCjMK4k3NDYzsjA1MTU2Mrc0I01YSZw3/VFSkJBAemJJanZqakFqUXxRaU5q
	8SFGJg5OqQbGNKYvlhPnZglu+P8x606sOZPchesGWVGn1F0CT0wpOHNBpj/9s8w1HbFbe/pS
	rt740+JzIu3ELoVXMcGff5yc3Fp2tHUa+8nSYhHtg4fau2e2C650Tw0RnSlqdX5X+Szt7SFz
	nkr8f6azL7fkWVTCK+dtStqz1wS/4tT9+2yFfJ38Rz25/RlWSizFGYmGWsxFxYkABl3ZabgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd1GsdfBBp82qVpc3jWHzeLgwjZG
	i9uNK9gs3t6ZzuLA4rF5hZZH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMGYcWtTMUjBRuGLHUbMGxjMCXYycHBICJhIXp7czQdhiEhfurWfrYuTiEBJY
	xChx5PkOKOc1o8TD+zPYQap4BbQk/j7sAutgEVCVePp7OguIzQYU3//iBhuILSoQJrFy+hUW
	iHpBiR+T74HZIgIaEr+vXGEFGcos0M8ocX7SFEaQhLCAj8Stn6fBmoUEdCQOHF3PCmJzCuhK
	nF36FizODBTf3zoNypaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBMfpMegfjqgaLQ4wCHIxKPLw7XF8FC7EmlhVX5h5ilOBgVhLhddgCFOJNSays
	Si3Kjy8qzUktPsRoCgyCicxSosn5wPSRVxJvaGxiZmRpZG5oYWRsriTOe7DVOlBIID2xJDU7
	NbUgtQimj4mDU6qBMaVU9qC5Y802eVErpstKDItbtIozGSPu/0o6dN5lXp1j7g5GjnAT4QUT
	ri1PbH2jzrik3jh6hZVbYHiA0vlndxVL14U52MxjPzgt6aTpreyZDpbRibUNNy7nSUbavtsW
	6hJxeMsLZwaV0K2afAaNnXxWJQnpB+O039T1G4bzPHj6S5TLSViJpTgj0VCLuag4EQAuib3T
	5wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Randy,

Thanks for your report.

I catched this issue. So, I fix this bug already. You can check it on following url:
- http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-test&id=5e519b04db6c5b42f8d8ee246c16903c130b5fd5


Best Regards,
Chanwoo Choi

On 08/13/2014 04:22 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build errors in extcon-sm5502.c by making EXTCON_SM5502 depend
> on I2C since it selects REGMAP_I2C.  The build errors happen when
> CONFIG_I2C=m and CONFIG_EXTCON_SM5502=y. This Kconfig change causes
> CONFIG_EXTCON_SM5502 to be =m when CONFIG_I2C=m.
> 
> drivers/built-in.o: In function `regmap_smbus_byte_reg_read':
> regmap-i2c.c:(.text+0x5030a): undefined reference to `i2c_smbus_read_byte_data'
> drivers/built-in.o: In function `regmap_smbus_byte_reg_write':
> regmap-i2c.c:(.text+0x50338): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `regmap_smbus_word_reg_read':
> regmap-i2c.c:(.text+0x50356): undefined reference to `i2c_smbus_read_word_data'
> drivers/built-in.o: In function `regmap_smbus_word_reg_write':
> regmap-i2c.c:(.text+0x50384): undefined reference to `i2c_smbus_write_word_data'
> drivers/built-in.o: In function `regmap_i2c_read':
> regmap-i2c.c:(.text+0x503cf): undefined reference to `i2c_transfer'
> drivers/built-in.o: In function `regmap_i2c_gather_write':
> regmap-i2c.c:(.text+0x50442): undefined reference to `i2c_transfer'
> drivers/built-in.o: In function `regmap_i2c_write':
> regmap-i2c.c:(.text+0x50474): undefined reference to `i2c_master_send'
> drivers/built-in.o: In function `sm5502_muic_i2c_init':
> extcon-sm5502.c:(.init.text+0x6630): undefined reference to `i2c_register_driver'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:	MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc:	Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-next-20140813/drivers/extcon/Kconfig
> ===================================================================
> --- linux-next-20140813.orig/drivers/extcon/Kconfig
> +++ linux-next-20140813/drivers/extcon/Kconfig
> @@ -72,6 +72,7 @@ config EXTCON_PALMAS
>  
>  config EXTCON_SM5502
>  	tristate "SM5502 EXTCON support"
> +	depends on I2C
>  	select IRQ_DOMAIN
>  	select REGMAP_I2C
>  	select REGMAP_IRQ
> 

