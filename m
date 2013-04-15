Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab3DOAVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 20:21:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46989 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab3DOAVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 20:21:53 -0400
X-AuditID: cbfee68d-b7f786d000005188-9c-516b481fa73b
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Haojian Zhuang'" <haojian.zhuang@linaro.org>,
        "'Jonghwan Choi'" <jhbird.choi@gmail.com>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1365864369-10563-1-git-send-email-jhbird.choi@samsung.com>
 <CAD6h2NQ06xL_E-BrKFNM-U0g4Xd+8PhPj=zzr9-qhZm+-rei+A@mail.gmail.com>
In-reply-to: <CAD6h2NQ06xL_E-BrKFNM-U0g4Xd+8PhPj=zzr9-qhZm+-rei+A@mail.gmail.com>
Subject: RE: [PATCH 3.8-stable] gpio: fix wrong checking condition for gpio
 range
Date: Mon, 15 Apr 2013 09:21:52 +0900
Message-id: <005b01ce396f$3a67fe50$af37faf0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac44W0wVTW5of+rpS9mDuiScq2AZfwBE9SXA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zfV15j+xAg1tTpCwunzvMaLH3yFoW
	iyl/ljNZXN41h81iwcZHjA6sHjtn3WX3uHNtD5vH501yAcxRXDYpqTmZZalF+nYJXBkTTi1n
	LjjFVvHi+DPGBsaprF2MHBwSAiYSsxpVuxg5gUwxiQv31rN1MXJxCAksY5TY3XeSDSJhInHy
	+2dmiMR0Rok5U9+yQDh/GSWmt01iBqliE9CVOLZ+CyuILSIQLbFv7Q4mEJtZIE3i9ezDTBAN
	fYwSFw+dBmvgFAiWOPn2HtgKYSD7ycdnYM0sAqoS2xdcYAGxeQXsJK68ugVlC0r8mHyPBWKo
	lsT6ncehFshLbF7zlhniHXWJR391IW4wknjSegqqXERi34t3jCA3SAgcY5doPvOSCWKXgMS3
	yYdYIHplJTYdYIb4WFLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJDveLE
	3OLSvHS95PzcTYyQuOzdwXj7gPUhxmSg9ROZpUST84FxnVcSb2hsZmRhamJqbGRuaUaasJI4
	r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRiGhlQ0H8vpmZHyttfwVMnfej12HWtp3
	vBYolNwoYrNHvXB91b4yjsLNBjMuamdESXZpXS32bf90MiBtsZVfa2WteNrD5Sz2B4QWRWlY
	Xvky69G31Vebl+2998eYvynpycPD3VaH9xilRKXmln1WeVmwr7JA6tFazc5is9wdH324vp67
	cFqrVomlOCPRUIu5qDgRAMEaVH7hAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQV15j+xAgwlLxSwunzvMaLH3yFoW
	iyl/ljNZXN41h81iwcZHjA6sHjtn3WX3uHNtD5vH501yAcxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZE04tZy44xVbx4vgzxgbGqaxdjJwcEgImEie/f2aGsMUkLtxb
	z9bFyMUhJDCdUWLO1LcsEM5fRonpbZPAqtgEdCWOrd8C1i0iEC2xb+0OJhCbWSBN4vXsw0wQ
	DX2MEhcPnQZr4BQIljj59h4biC0MZD/5+AysmUVAVWL7ggssIDavgJ3ElVe3oGxBiR+T77FA
	DNWSWL/zONQCeYnNa94CzeQAOlVd4tFfXYgbjCSetJ6CKheR2PfiHeMERqFZSCbNQjJpFpJJ
	s5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHPfPpHYwrmywOMQowMGoxMM7QTs7
	UIg1say4MvcQowQHs5IIbyALUIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgSkpryTe0NjE
	zMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYy5a7lFyc+MXvV+Ds8sRp
	a5Sflp8+Y2L6uvub6aO2CYoPTqYeMbk4s7LK/8qpo7wfk86qyUoefFxsIzdT/FhTcvPvTSLH
	rPd8mSRu0M3y5afN/SkOtiWOq5e/6rYQXCM8cVXJPK72lceCHkVYSk+/2tTYsWlqZUy7++sL
	i/+nivDILJobPa+nQomlOCPRUIu5qDgRAAPx2WI/AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Haojian Ahuang.

> > This patch looks like it should be in the 3.8-stable tree, should we
> apply
> > it?
> >
> 
> It could be merged into 3.8-stable tree.
>

Thanks~

Best Regards.

> -----Original Message-----
> From: Haojian Zhuang [mailto:haojian.zhuang@linaro.org]
> Sent: Sunday, April 14, 2013 12:27 AM
> To: Jonghwan Choi
> Cc: Linus Walleij; stable@vger.kernel.org; linux-kernel@vger.kernel.org;
> Jonghwan Choi
> Subject: Re: [PATCH 3.8-stable] gpio: fix wrong checking condition for
> gpio range
> 
> On 13 April 2013 22:46, Jonghwan Choi <jhbird.choi@gmail.com> wrote:
> > From: Haojian Zhuang <haojian.zhuang@linaro.org>
> >
> > This patch looks like it should be in the 3.8-stable tree, should we
> apply
> > it?
> >
> 
> It could be merged into 3.8-stable tree.
> 
> Regards
> Haojian

