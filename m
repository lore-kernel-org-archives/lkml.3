Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3B0CMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:12:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57566 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759541Ab3B0CMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:12:19 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-d0-512d6b81148b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Tejun Heo'" <tj@kernel.org>,
        "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008c01ce13bf$8d2cd550$a7867ff0$%han@samsung.com>
 <20130226223304.GB20670@core.coreip.homeip.net>
In-reply-to: <20130226223304.GB20670@core.coreip.homeip.net>
Subject: Re: [PATCH V2] rtc: add devm_rtc_device_{register,unregister}()
Date: Wed, 27 Feb 2013 11:12:17 +0900
Message-id: <007601ce148f$ddce3280$996a9780$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4UcUFQ7KIEJNj+Qa6wq3YdTInN6QAHYKlw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI93GbN1Ag/3TDCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGmt1vWQuuc1RMWvGQpYHxM1sXIyeHhICJRP/3HawQtpjEhXvr
	geJcHEICyxglvs+7AeRwgBW93+UFEV/EKLF6+ixWCGc2k0TfkSNgk9gE1CS+fDnMDtIgImAo
	MWNNFUgNs8B3RompJ98wgtQICeRLHDl1AczmFLCR+HjiGBNIvbCAh8SXz2ogJouAqsTHb0og
	FbwCthJ7elazQdiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4kx1iUd/dUHCIgJGEp/edkKV
	i0jse/GOEeQaCYFl7BKrrp5nB0mwCAhIfJt8iAWiV1Zi0wFmSDBIShxccYNlAqPELCSbZyHZ
	PAvJ5llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERJVfTsYbx6wPsSYDLR+IrOU
	aHI+MCrzSuINjY1NzExMTcwtTc1NSRNWEueVvyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoHRsuS9aM3px/wSDGcllJInPo6cxJu4/Mu7utjLwZduR/w4ssYqdWs0V9/PRCdtjpTCnk1P
	uo5Euh3Z7ZOcM/nhqbAppc5XEubdPbeLq2bv1W+ZbiUzP37RkVpkcGeVSoGpzsrvJrO8Dy77
	Zehbd/q20s9flp38y22jfD4FiATZxC//ceFYw69eJZbijERDLeai4kQANaGAusACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG5jtm6gwbHpWhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY83ut6wF1zkqJq14yNLA
	+Jmti5GDQ0LAROL9Lq8uRk4gU0ziwr31QGEuDiGBRYwSq6fPYoVwZjNJ9B05wgZSxSagJvHl
	y2F2kGYRAUOJGWuqQGqYBb4zSkw9+YYRpEZIIF/iyKkLYDangI3ExxPHmEDqhQU8JL58VgMx
	WQRUJT5+UwKp4BWwldjTs5oNwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQJ6tLPPqrCxIW
	ETCS+PS2E6pcRGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWle
	ul5yfu4mRnDMPpPawbiyweIQowAHoxIP74JLOoFCrIllxZW5hxglOJiVRHg/HgAK8aYkVlal
	FuXHF5XmpBYfYkwG+nMis5Rocj4wneSVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6Yklq
	dmpqQWoRzBYmDk6pBsZpjesDb79SPPn566FopV/JOV5/ZDi3LWEsviRYFbtzsf+sv95Hi7W1
	uYW/rXO4U1S+ViDhfuW5ysmVwT6rFrd6LjxxwO2C1G6O8got/ytvJ8QF2zQfPx9gKN3+NGrz
	2so4yf3ck86uSV45wUGj9nuFu5oW+4sDui26TFKSa2PkLXTXR+6tUlBiKc5INNRiLipOBAC4
	8ysqHQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 27, 2013 7:33 AM, Dmitry Torokhov wrote:
> 
> On Tue, Feb 26, 2013 at 10:21:06AM +0900, Jingoo Han wrote:
> > +/**
> > + * devm_rtc_device_unregister - resource managed devm_rtc_device_unregister()
> > + * @dev: the device to unregister
> > + * @rtc: the RTC class device to unregister
> > + *
> > + * Deallocated a rtc allocated with devm_rtc_device_register(). Normally this
> > + * function will not need to be called and the resource management code will
> > + * ensure that the resource is freed.
> > + */
> > +void devm_rtc_device_unregister(struct device *dev, struct rtc_device *rtc)
> 
> Why do you need a separate function? You can add a flag to struct rtc_device
> so it knows whether it is devm-managed or not and behave accordingly.
> And then you can do
> 
> #define devm_rtc_device_unregister rtc_device_unregister

Um, I don't prefer that way using additional a flag.

Also, most of other devm_* functions are using a separate functions
such as devm_pwm_put(), devm_regulator_put(),devm_usb_put_phy(), etc.


> 
> Thanks.
> 
> --
> Dmitry

