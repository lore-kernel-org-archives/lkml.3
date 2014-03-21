Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbaCUAv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:51:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34747 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965592AbaCUAvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:51:19 -0400
X-AuditID: cbfee68f-b7f156d00000276c-60-532b8d0410f3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>,
        "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Haavard Skinnemoen'" <hskinnemoen@gmail.com>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        linux-leds@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-15-git-send-email-alexandre.belloni@free-electrons.com>
 <20140319142231.GF20872@samfundet.no>
In-reply-to: <20140319142231.GF20872@samfundet.no>
Subject: Re: [PATCH 14/16] backlight: atmel-pwm-bl: remove obsolete driver
Date: Fri, 21 Mar 2014 09:51:16 +0900
Message-id: <000101cf449f$aa609960$ff21cc20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9DfrDoh3MIN/vpSOKFDxQclAeBqABIJjbA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zY12WXu1gg2+XjCw6ri1msji6cyKT
	xctDmhbd6x6xWzQvXs9m8eNrM4vF5YWXWC02Pb7GanGi7wOrxeVdc9gstr5Zx2hx9+4qRotv
	l5vZLdY9fMFksXvXU1aLn7vmsTgIeCz4tZXF48mmi4weO2fdZfd4deEOi8f+uWvYPTYvqffY
	M/8Hq8eiU5/ZPfq2rGL0+LxJLoArissmJTUnsyy1SN8ugSvj7v+zrAX32CvuPtvE1MA4l62L
	kZNDQsBE4t78Z4wQtpjEhXvrgeJcHEICyxglXjZPYO1i5AAr2toqD1IjJDCdUeLLLy+Imt+M
	Euf3rmEHSbAJqEl8+XIYzBYRKJT4dXQr2CBmgS4WiWlHpzFDdJwCmjr/Mtg6TgEjiXX/b4Cd
	ISzgJTHz605mEJtFQFXix6VXrCA2r4CtxPStN1kgbEGJH5PvgdnMAloS63ceZ4Kw5SU2r3nL
	DHGpusSjv7ogpgjQ+ImTNSEqRCT2vXjHCHKChMAFDom2dbfZIVYJSHybfIgFolVWYtMBZkhA
	SEocXHGDZQKjxCwki2chWTwLyeJZSFYsYGRZxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRGS
	RPp3MN49YH2IMRlo/URmKdHkfGASyiuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjBVdJ4/fM/5gKvF6vx7zSXUnn7ZnhiY7wm8KPpNd2MNdpZlx
	b1JAspXvK+XFu5el+MbOaezaa/imk4eRXUv1ccKBVy/P2+6QYnW7dGzv5zrGwxN3G2+Z2eXb
	bRxzeDfnS4Xz6+efL2677t8YuZlLZPKL763aa9l9dy+5Me/Bk1OLK3fu8472MVZiKc5INNRi
	LipOBADaYZqeOAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e+xoC5Lr3awwfwVuhYd1xYzWRzdOZHJ
	4uUhTYvudY/YLZoXr2ez+PG1mcXi8sJLrBabHl9jtTjR94HV4vKuOWwWW9+sY7S4e3cVo8W3
	y83sFusevmCy2L3rKavFz13zWBwEPBb82sri8WTTRUaPnbPusnu8unCHxWP/3DXsHpuX1Hvs
	mf+D1WPRqc/sHn1bVjF6fN4kF8AV1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQP0i5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQ
	sI4x4+7/s6wF99gr7j7bxNTAOJeti5GDQ0LARGJrq3wXIyeQKSZx4d56NhBbSGA6o8SXX15d
	jFxA9m9GifN717CDJNgE1CS+fDkMZosIFEr8OrqVDaSIWaCLRWLa0WnMEB2nGCVezr/MCFLF
	KWAkse7/DbCxwgJeEjO/7mQGsVkEVCV+XHrFCmLzCthKTN96kwXCFpT4MfkemM0soCWxfudx
	JghbXmLzmrfMEFerSzz6qwtiigCNnzhZE6JCRGLfi3eMExiFZiEZNAvJoFlIBs1C0rKAkWUV
	o2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCKeia9g3FVg8UhRgEORiUe3gpO7WAh1sSy4src
	Q4wSHMxKIryvu4FCvCmJlVWpRfnxRaU5qcWHGJOB/pzILCWanA9Mn3kl8YbGJmZGlkZmFkYm
	5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwNjwX8nY00ZcIaYm2EZXxvfmaqOaWvW2
	JpP+NWY8svuLgxs/NHR0bBDfK3Fy0vbqygm71K4s8TDOd+GxOHWSLT5Vr+GmcPDFAl8HL9Ef
	J5J/OLy6dz3Y3qE18MrbnaHBikq5B5LvuRkueNd4YNP9mRd9q5TyV71Trc9i+JurYrpg55nb
	6bIPlViKMxINtZiLihMBGcVaoZUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 19, 2014 11:23 PM, Hans-Christian Egtvedt wrote:
> Around Wed 19 Mar 2014 14:03:27 +0100 or thereabout, Alexandre Belloni wrote:
> > The atmel-pwm-bl driver is now obsolete. It is not used by any mainlined boards
> > and is replaced by the generic pwm_bl with the pawm-atmel driver using the
> > generic PWM framework.
> >
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> > ---
> >  drivers/video/backlight/Kconfig        |  11 --
> >  drivers/video/backlight/Makefile       |   1 -
> >  drivers/video/backlight/atmel-pwm-bl.c | 223 ---------------------------------
> >  include/linux/atmel-pwm-bl.h           |  43 -------
> >  4 files changed, 278 deletions(-)
> >  delete mode 100644 drivers/video/backlight/atmel-pwm-bl.c
> >  delete mode 100644 include/linux/atmel-pwm-bl.h

