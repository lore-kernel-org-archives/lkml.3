Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3G3Nde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:33:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45115 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3G3Ndb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:33:31 -0400
X-AuditID: cbfee691-b7fef6d000002d62-35-51f7c0aa9f1f
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        "'Mark Brown'" <broonie@linaro.org>
References: <1375184777-25404-1-git-send-email-broonie@kernel.org>
 <1375184777-25404-4-git-send-email-broonie@kernel.org>
In-reply-to: <1375184777-25404-4-git-send-email-broonie@kernel.org>
Subject: RE: [PATCH 4/5] mmc: dw_mmc: Indicate that regulators may be absent
Date: Tue, 30 Jul 2013 22:33:30 +0900
Message-id: <003901ce8d29$610ab3f0$23201bd0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6NGpIXkIXiE4DgQnGyDP1z8lLMMgADmrAA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zI91VB74HGvyarW4x9eETNotN16+z
	Wmx/vZHN4savNlaLb1c6mCzeH3rGbLHp8TVWi8u75rBZHPnfz+jA6bFz1l12j02rOtk8Dl1Z
	y+hx59oeNo/NS+o9bv97zOzRt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGVvXPmIvOMpUce5R
	I2MDYwdTFyMnh4SAicST7ZPYIGwxiQv31gPZXBxCAssYJRY0PYYrmrX6MgtEYhGjxO4pkxgh
	nD+MEm+WtoBVsQloSfx984YZJCEiMB2o6scasCpmgRWMEqe/rWAGqRISqJZYsnAG2EJOAWeJ
	BSunsIDYwgI+Ej+uvGIHsVkEVCVaP18Ei/MK2EpcP3MWyhaU+DH5HpjNLGAg8X5WHyuELS+x
	ec1boPkcQLeqSzz6qwsSFhEwkujaeIAZokREYt+Ld2D3SAhM5JCYP/kqC8QuAYlvkw+xQPTK
	SmyCqJcQkJQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchUrzgxt7g0L10v
	OT93EyMk5ifuYLx/wPoQYzLQ+onMUqLJ+cCUkVcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxvJFH5VnlHZOC31vIfpcdGrxq0fGaWrqpz5WzVUv
	tbumtjDKo8/u45aYzM87p4t+UXd8277v2s7Vz6dZ9a7Ws46tPaik0nY9Qe9X+fL8ld+ftppk
	21Zc/iOeeeGo6ltT1Y8qK1TnllzVbF8Qeb/E4vaDdxP3W09uOxyzYpujkOL2+Jni/+/enaHE
	UpyRaKjFXFScCADff7kfDwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAd1VB74HGjx/r2Qx9eETNotN16+z
	Wmx/vZHN4savNlaLb1c6mCzeH3rGbLHp8TVWi8u75rBZHPnfz+jA6bFz1l12j02rOtk8Dl1Z
	y+hx59oeNo/NS+o9bv97zOzRt2UVo8fnTXIBHFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7x
	pmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QPcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUN
	CYLrMTJAAwnrGDO2rn3EXnCUqeLco0bGBsYOpi5GTg4JAROJWasvs0DYYhIX7q1n62Lk4hAS
	WMQosXvKJEYI5w+jxJulLWAdbAJaEn/fvGEGSYgITAeq+rEGrIpZYAWjxOlvK5hBqoQEqiWW
	LJzBBmJzCjhLLFg5BWyHsICPxI8rr9hBbBYBVYnWzxfB4rwCthLXz5yFsgUlfky+B2YzCxhI
	vJ/Vxwphy0tsXvMWaD4H0K3qEo/+6oKERQSMJLo2HmCGKBGR2PfiHeMERqFZSCbNQjJpFpJJ
	s5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnFCeSe1gXNlgcYhRgINRiYd3Q8G3
	QCHWxLLiytxDjBIczEoivOcnfg8U4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgsssriTc0
	NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkY+oRhVg0ajox6TRN2u
	Tfu6x+tsBPf3LwtnOTG7Chv9du762BVbpL7uLiOHdsJzxXn/Pgg2O81/PMFBL3eL+9qjWvnG
	82Zrq+/w0jaM9m5/UsYSaHqs89/3LrnDxhe83kYZNtrsLuf+M/v8WdeCxiCLa2+DNiT85vNn
	UO9L48vXFufZ8GHmASWW4oxEQy3mouJEAOnaz+1sAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, July 30, 2013, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Use regulator_get_optional() to tell the core that requests for regulators
> can fail in a real system.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks,
Seungwon Jeon

