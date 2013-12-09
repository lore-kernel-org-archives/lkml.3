Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199Ab3LICB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:01:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40185 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759074Ab3LICB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:01:27 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-5b-52a52474acf9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "=?iso-8859-1?Q?'Heiko_St=FCbner'?=" <heiko@sntech.de>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Axel Lin'" <axel.lin@ingics.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
 <000d01cef252$4680cf90$d3826eb0$%han@samsung.com>
 <201312061012.05535.heiko@sntech.de> <20131206120907.GE29268@sirena.org.uk>
In-reply-to: <20131206120907.GE29268@sirena.org.uk>
Subject: Re: [PATCH 4/6] regulator: gpio-regulator: use
 devm_regulator_register()
Date: Mon, 09 Dec 2013 11:01:24 +0900
Message-id: <001401cef482$90461180$b0d23480$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7ye/s4eo8IDt0+RSStRUmDo2FdOQCBfndg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zY90SlaVBBjsbNS2OzPnKbDH14RM2
	i/+PXrNaXF54idXi25UOJovLu+awObB57Jx1l92j7WeZx6ZVnWwefVtWMXpsvzaP2ePzJrkA
	tigum5TUnMyy1CJ9uwSujJ9HbQoWsFVsmfKEpYHxF0sXIyeHhICJxIcDjWwQtpjEhXvrgWwu
	DiGBZYwSd6dMZoUpWtK7nBkisYhR4u3LNhYI5xejxIL128FGsQmoSXz5cpgdxBYRiJW4uGIR
	2ChmgX5GiZNvJ7FCdOxnlHj5cDcTSBWngLHE9GV7wZYLCwRLzDv1lRHEZhFQlejcdxishlfA
	VmLN9IPsELagxI/J98C2MQvoSPR+/8YMYWtLPHl3AWgBB9Ct6hKP/upCHGEkcXPlXqgSEYl9
	L94xgtwgIfCWXeLOzy/sELsEJL5NPsQC0SsrsekAM8TLkhIHV9xgmcAoMQvJ5llINs9CsnkW
	khULGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoTE78QdjPcPWB9iTAZaP5FZSjQ5Hxj/
	eSXxhsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeEFO
	eK5f7PO+8jTFmJqLmms+LMw91CygWrs2jetOcNCX3oVnZx2rnDWpSTTvv1ytvFvDh17RPWq7
	nsvtmngnMvb6n2lh2+d6x77ZvJJZ7fbXg4/nqaf3RD/zf+16/Nah+DsM5j9//tzGZMDWPFtc
	XtR9++m/18+Uf9UuF1snO1+0jeOM+sRNE5VYijMSDbWYi4oTARNyDoL1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd0SlaVBBquWqFocmfOV2WLqwyds
	Fv8fvWa1uLzwEqvFtysdTBaXd81hc2Dz2DnrLrtH288yj02rOtk8+rasYvTYfm0es8fnTXIB
	bFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDN+HrUpWMBWsWXKE5YGxl8s
	XYycHBICJhJLepczQ9hiEhfurWfrYuTiEBJYxCjx9mUbC4Tzi1FiwfrtYB1sAmoSX74cZgex
	RQRiJS6uWATWwSzQzyhx8u0kVoiO/YwSLx/uZgKp4hQwlpi+bC8biC0sECwx79RXRhCbRUBV
	onPfYbAaXgFbiTXTD7JD2IISPybfA9vGLKAj0fv9GzOErS3x5N0FoAUcQLeqSzz6qwtxhJHE
	zZV7oUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn
	525iBCeHZ9I7GFc1WBxiFOBgVOLhXcG6NEiINbGsuDL3EKMEB7OSCK/SiSVBQrwpiZVVqUX5
	8UWlOanFhxiTgR6dyCwlmpwPTFx5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5N
	LUgtgtnCxMEp1cDIe+bPPsHi+N/vRTX7ow8oztb8FBjqlng719nKLp+5/WyD7a4Hd/ymnpk0
	hafqHveqngk1NxfccuJmL1Fc9GlRUoyzwm0ZsZg5q229Tl2wnb5UIkz96ff1XV9nT//J5Mma
	t43B/kLMuj+vPSVaTb+p3Hf3EZ8z4bvIGYNWRin7uavlKlwWKi9SYinOSDTUYi4qTgQA0O8w
	R1IDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 06, 2013 9:09 PM, Mark Brown wrote:
> On Fri, Dec 06, 2013 at 10:12:05AM +0100, Heiko Stübner wrote:
> 
> > I'm not this firm in the core driver/device behaviour, but when looking at
> > __device_release_driver I see that the remove callback runs before
> > devres_release_all, which would effectively free the gpios before the
> > regulator gets unregistered - is this racy with a regulator change at the same
> > time?
> 
> Yes, the rest of the driver really needs to be converted to devm_ at the
> same time.

The gpios is requested by gpio_request_array().
However, devm_gpio_request_array() is not supported yet,
so the rest of the driver cannot be converted to devm_.

Mark Brown,
Please ignore this patch.

Best regards,
Jingoo Han

