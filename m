Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaAWJBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:01:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41577 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaAWJA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:00:58 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-1a-52e0da4812ce
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jenny TC'" <jenny.tc@intel.com>, linux-kernel@vger.kernel.org,
        "'Dmitry Eremin-Solenikov'" <dbaryshkov@gmail.com>
Cc: "'Anton Vorontsov'" <cbouatmailru@gmail.com>,
        "'Anton Vorontsov'" <anton.vorontsov@linaro.org>,
        "'Kim Milo'" <Milo.Kim@ti.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Rupesh Kumar'" <rupesh.kumar@stericsson.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "=?utf-8?Q?'Pali_Roh=C3=A1r'?=" <pali.rohar@gmail.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rhyland Klein'" <rklein@nvidia.com>, "'Pavel Machek'" <pavel@ucw.cz>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Sebastian Reichel'" <sre@ring0.de>, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, linux-omap@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
 <1390411194-21410-2-git-send-email-jenny.tc@intel.com>
In-reply-to: <1390411194-21410-2-git-send-email-jenny.tc@intel.com>
Subject: RE: [PATCH 1/4] power_supply: Add inlmt,iterm, min/max temp props
Date: Thu, 23 Jan 2014 18:00:55 +0900
Message-id: <000101cf1819$a0321700$e0964500$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8XVDH3yINSqG88TWCsKui/jbHBogAxTRng
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t8zA12PWw+CDO7s5rBY88LB4mLrbRaL
	f7NPsVnMPH+Z3eL6l+esFpOevGe2mLhyMrPF4696Fmu/9rBbXF54idViyeT5rBb3vx5ltLi8
	aw6bxewl/SwWty/zWiz/tY7FYuLp30wWd08dZbNYdnw1q8X7+bcYLU7+6WW0WP4pwmL/FS8H
	cY+j51+xerQ097B5fPs6icVj56y77B6Hvy5k8di8Qstj8Z6XTB53ru1h81jy5hCrR2/zOzaP
	lxN/s3nsPfSD3aNvyypGj+9L17B7HL+xncljxerv7AGCUVw2Kak5mWWpRfp2CVwZLRuWsxSc
	Zq9YOfElcwNjJ1sXIyeHhICJRFffBRYIW0ziwr31QHEuDiGBZYwSZ59egStaeeseC0RiOqNE
	04ezjBDOL0aJewtWM4FUsQmoSXz5cpgdxBYRKJU4/uwDM0gRs8AUNolLR24xgySEBKolvk9f
	BTaWU8BZYlvvJbBmYQEvic/P1zKC2CwCqhIH55wGi/MK2Er0nz3ICGELSvyYDHIGB9BQdYkp
	U3JBwswC8hKb17xlBglLAIUf/dWFOMFI4tydCUwQJSIS+168A7tZQmA9p8TZ7VNYIFYJSHyb
	fIgFoldWYtMBZoiHJSUOrrjBMoFRYhaSxbMQFs9CsngWkg0LGFlWMYqmFiQXFCelF5nqFSfm
	Fpfmpesl5+duYoQksIk7GO8fsD7EmAy0fSKzlGhyPjAB5pXEGxqbGVmYmpgaG5lbmpEmrCTO
	m/4oKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDI8ftGDULIatvwXXxtuLr9vvtmfLXcN3S
	Ph9nZ+YH03bwHlOw9F8860nthGntRgo953hmekksm+od+Xq7zuc9q5N8PLWPPP22Nd96/U1z
	z8eKeS3ajOb3nYM23lmn+1367JHMLfPnV876bMPHlpXXE2TqJ8088eHn/ZMvVD1vW8J7J3D1
	yX9uYUosxRmJhlrMRcWJAP0juvl2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsVy+t9jQV2PWw+CDHb/YbRY88LB4mLrbRaL
	f7NPsVnMPH+Z3eL6l+esFpOevGe2mLhyMrPF4696Fmu/9rBbXF54idViyeT5rBb3vx5ltLi8
	aw6bxewl/SwWty/zWiz/tY7FYuLp30wWd08dZbNYdnw1q8X7+bcYLU7+6WW0WP4pwmL/FS8H
	cY+j51+xerQ097B5fPs6icVj56y77B6Hvy5k8di8Qstj8Z6XTB53ru1h81jy5hCrR2/zOzaP
	lxN/s3nsPfSD3aNvyypGj+9L17B7HL+xncljxerv7AGCUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTnAkFBSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYxZrRsWM5ScJq9YuXEl8wNjJ1sXYycHBICJhIrb91jgbDFJC7cWw8U
	5+IQEpjOKNH04SwjhPOLUeLegtVMIFVsAmoSX74cZgexRQRKJY4/+8AMUsQsMIVN4tKRW8wg
	CSGBaonv01eBreAUcJbY1nsJrFlYwEvi8/O1jCA2i4CqxME5p8HivAK2Ev1nDzJC2IISPyaD
	nMQBNFRdYsqUXJAws4C8xOY1b5lBwhJA4Ud/dSFOMJI4d2cCE0SJiMS+F+8YJzAKzUIyaBbC
	oFlIBs1C0rGAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnB6fCa9g3FVg8UhRgEORiUe
	3oQv94OEWBPLiitzDzFKcDArifD+O/AgSIg3JbGyKrUoP76oNCe1+BBjMtCbE5mlRJPzgak7
	ryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYE7Lsgt4f6Ky/
	YbHwVrhwWbHfbImZp/cVpAQZbHi26L9m4b8dZkW37Q9O3jK1NpqjMe/gf7Pp5yvkbBzWHD9a
	fez6QenrhVtZmWMu67kGTQqtjDO5rcBWHLd/kYhhy62P1m8VjGt5fyeENUVWWOxVD2fUePCL
	d9Yqn6maUstKtMqCQ5X5LsUqsRRnJBpqMRcVJwIAV2X9k9MDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 23, 2014 2:20 AM, Jenny TC wrote:
> 
> Add new power supply properties for input current, charge termination
> current, min and max temperature
> 
> POWER_SUPPLY_PROP_TEMP_MIN - minimum operatable temperature
> POWER_SUPPLY_PROP_TEMP_MAX - maximum operatable temperature
> 
> POWER_SUPPLY_PROP_INLMT - input current limit programmed by charger. Indicates
> the input current for a charging source.
> 
> POWER_SUPPLY_PROP_CHARGE_TERM_CUR - Charge termination current used to detect
> the end of charge condition
> 
> Change-Id: Ifb40662bbfa24387ac7493ffa7ce01c6fae7e800

Please remove this 'Change-Id' from the commit message.

Best regards,
Jingoo Han

> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
>  Documentation/power/power_supply_class.txt |    6 ++++++
>  drivers/power/power_supply_sysfs.c         |    4 ++++
>  include/linux/power_supply.h               |    4 ++++
>  3 files changed, 14 insertions(+)


