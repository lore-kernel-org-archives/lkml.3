Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3BDITR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:19:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63331 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3BDITP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:19:15 -0500
X-AuditID: cbfee60e-b7f1a6d000000feb-33-510f6f01c1d5
Date: Mon, 04 Feb 2013 08:19:13 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v4 4/4] PM: Devfreq: Add Exynos5-bus devfreq driver for
 Exynos5250
To: Abhilash Kesavan <kesavan.abhilash@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        =?euc-kr?Q?=B1=E8=B1=B9=C1=F8?= <kgene.kim@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        =?euc-kr?Q?=C3=D6=C1=BE=C8=AF?= <jhbird.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20130204081114827@myungjoo.ham
Msgkey: 20130204081114827@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130204081114827@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17352980.268481359965953092.JavaMail.weblogic@epml13>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t8zLV2mfP5Ag2kpFpd3zWFzYPT4vEku
	gDGKyyYlNSezLLVI3y6BK+PFi9+MBZMUKy5euMzawLhAoYuRk0NIQF1i0ZKTbCC2hICJxM+3
	X9ghbDGJC/fWA8W5gGqWMUrc2f2XBabo+ek+VojEfEaJqx+3gyVYBFQk1nTMBerm4GAT0JOY
	+TkZxBQWiJL4sUMQxBQRMJbY2eEMUswscI1JYvlHeYgTlCTW7HsFNoRXQFDi5MwnUJtUJToe
	7WYFaeUVUJM4+1QDIiwhMWv6BVYIm1diRvtTqHI5iWlf1zBD2NIS52dtYIT5ZPH3x1Bxfolj
	t3cwgYwE6X1yPxhmzO7NX6CBICAx9cxBqFYtiUed86Fa+STWLHzLAjNm16nlzDC997fMZYL4
	SlFiSvdDdghbS+LLj31s6L7iFXCSuNn0lWkCo/IsJKlZSNpnIWlHVrOAkWUVo2hqQXJBcVJ6
	qolecWJucWleul5yfu4mRkg64NvBOK/B4hCjAAejEg8v4y++QCHWxLLiytxDjBIczEoivFeN
	gEK8KYmVValF+fFFpTmpxYcYk4GRN5FZSjQ5H5iq8kriDY0NjA0NLQ3NTC1NDUgTVhLnVaqY
	HiAkkJ5YkpqdmlqQWgSzhYmDU6qBUe/Lernjpo+feaXvPs9SJrX4Wpd2zBK1p7Z2TBazrO99
	ev3HOHAO/+knIqtin0tvmRCTWLJEz/daoaL4uSWNslr/Tv7WeWl20y8g/kGFqnLFNYPa3EzF
	b7cY3h4r9A7gCI+9qmRnn1wycW9ggMqWZVsSFsxckWQjU72wbcvZnLpqX272/vDpSizFGYmG
	WsxFxYkAEIRB1EsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/t6bqM+fyBBtMvmFtc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jBcvfjMWTFKsuHjhMmsD4wKFLkZODiEBdYlFS06ygdgSAiYSz0/3sULYYhIX7q0HinMB1cxn
	lLj6cTsLSIJFQEViTcdc9i5GDg42AT2JmZ+TQUxhgSiJHzsEQUwRAWOJnR3OIMXMAteYJJZ/
	lIfYpCSxZt8rsCG8AoISJ2c+YYHYpCrR8Wg3K0grr4CaxNmnGhBhCYlZ0y9AHcMrMaP9KVS5
	nMS0r2uYIWxpifOzNjDCHLz4+2OoOL/Esds7mEBGgvQ+uR8MM2b35i9QvwpITD1zEKpVS+JR
	53yoVj6JNQvfssCM2XVqOTNM7/0tc5kgvlKUmNL9kB3C1pL48mMfG7qveAWcJG42fWWawCg3
	C0lqFpL2WUjakdUsYGRZxSiaWpBcUJyUnmqiV5yYW1yal66XnJ+7iRGcmp7x7WCc12BxiFGA
	g1GJh5fxF1+gEGtiWXFl7iFGCQ5mJRHeq0ZAId6UxMqq1KL8+KLSnNTiQ4zJwMibyCwlmpwP
	TJt5JfGGxgbGhoaW5gamhkYWpAkrifMqVUwPEBJITyxJzU5NLUgtgtnCxMEp1cBomqQ78yfH
	8Xerv74NEV2R0Sa8dcGDxPkSXx+9nBRutnJVn6PaC/3rqQkb3+w0qGn8sOtt9ONPWezvnKIf
	qKR+7xLZZLBM3f6xmUUE+4O2R0o+Rg/ZLp79/plzlazsgafPKmyc/rYZT+HRC24+Zdbld7OR
	1XnDZYtGxp4/c/7W378oou7vtmCpEktxRqKhFnNRcSIABoPAB5EDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r148JW8m006931

> Hi,
> 
> > Sorry for being late.
> >
> > One concern is that I cannot apply Patch 1/4 directly as the .dts file isn't
> > available to me.
> > Do you intend to apply that patch to another tree and apply the other three
> > to devfreq tree?
> I have been merging the devfreq tree into Kgene's tree for my testing. I am not
> sure how this should get in, any suggestions ?

I'd suggest to send Patch 1/4 to Kgene and get it applied first if that patch is preliminary to the other patchset. If it is not, we can go seperated and independently.

> >
> > Another is the location of exynos_ppmu.h.
> > Who is going to refer exynos_ppmu.h?
> > If Exynos devfreq drivers are the only files to refer, wouldn't it be better
> > located at drivers/devfreq/exynos/ ?
> >
> > Or do you intend to let someone else (drivers located not in
> > drivers/devfreq) access exynos-ppmu?
> > (If so, who's going to be? and that means we are going to have
> > include/linux/devfreq/, I don't think it'd be appropriate to populate
> > include/linux with device driver specific headers)
> In an earlier comment on this patch Olof suggested I place it in
> include/linux/. It is going to be
> used only by Exynos and I will move it into drivers/devfreq/exynos as
> per your suggestion.

If it is to be used by Exynos non-devfreq drivers (e.g., Exynos ADC driver in drivers/iio/...), it should be stting on include/linux/devfreq/. If it is to be used by Exynos devfreq drivers only, it'd be better located at drivers/devfreq/exynos/. It appears to be still compatible with Olof's suggestion:

(quoting Olof) "Local defines that are used in just one C file can either go in that file, or in a header file that sits next to it instead of in the shared directory."



> >
> >
> >
> > And, there are errors (we do not have __devinit/__devexit anymore):
> >
> >   CC      drivers/devfreq/exynos/exynos5_bus.o
> > drivers/devfreq/exynos/exynos5_bus.c:315:18: error: expected =, ,, ;, asm or
> > __attribute__ before int
> > drivers/devfreq/exynos/exynos5_bus.c:430:18: error: expected =, ,, ;, asm or
> > __attribute__ before int
> > drivers/devfreq/exynos/exynos5_bus.c:462:11: error:
> > exynos5_busfreq_int_probe undeclared here (not in a function)
> > drivers/devfreq/exynos/exynos5_bus.c:463:2: error: implicit declaration of
> > function __devexit_p [-Werror=implicit-function-declaration]
> > drivers/devfreq/exynos/exynos5_bus.c:463:24: error:
> > exynos5_busfreq_int_remove undeclared here (not in a function)
> > drivers/devfreq/exynos/exynos5_bus.c:235:35: warning:
> > exynos5_devfreq_int_profile defined but not used [-Wunused-variable]
> > drivers/devfreq/exynos/exynos5_bus.c:243:12: warning:
> > exynos5250_init_int_tables defined but not used [-Wunused-function]
> > drivers/devfreq/exynos/exynos5_bus.c:259:12: warning:
> > exynos5_busfreq_int_pm_notifier_event defined but not used
> > [-Wunused-function]
> > cc1: some warnings being treated as errors
> I will fix these and re-post.
> >
> >
> >
> > Cheers,
> > MyungJoo.
> >
> Abhilash
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
