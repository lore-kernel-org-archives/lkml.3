Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbaJVLHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:07:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12007 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499AbaJVLG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:06:58 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-55-54478fcf036d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de, b29396@freescale.com,
        boris.brezillon@free-electrons.com, tomasz.figa@gmail.com,
        linux@arm.linux.org.uk, vikas.sajjan@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, kgene.kim@samsung.com, Li.Xiubo@freescale.com,
        geert+renesas@glider.be, swarren@nvidia.com
References: <1412066127-27063-1-git-send-email-pankaj.dubey@samsung.com>
 <20141007090923.GI25331@lee--X1>
In-reply-to: <20141007090923.GI25331@lee--X1>
Subject: RE: [PATCH v7] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Wed, 22 Oct 2014 16:36:28 +0530
Message-id: <001901cfede8$5554cc50$fffe64f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDZRVlgp8/5Ih7zB/yalgUesapzCwFxu/5wnh226aA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSo3u+3z3EoOGcnMXfScfYLR7u7Gex
	OPBiIYvF3NmTGC16F1xls7j/9SijReeFDlaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1eLG
	9BZWi45ljBardv1htLj5bDuTg4BHS3MPm8fvX5MYPZ5susjo8e9wP5PHxLO6Hjtn3WX3uHNt
	D5vH5iX1Hr3N79g8+rasYvT4vEkugDuKyyYlNSezLLVI3y6BK+NRxyXGglUiFXN+drA2MG4W
	6GLk4JAQMJHYtYy/i5ETyBSTuHBvPVsXIxeHkMBSRonbra/YIRImEi/azrJDJKYzSuyaeJIJ
	wvnLKHHk9Gw2kCo2AV2JJ+/nMoPYIgJqEjf3zGICsZkFepkl/r1kBLGFBLIlXv1bCRbnBKq/
	f2ElWK+wQJjE9dX3WUBsFgFViffP54Bt5hWwlGjqmcQIYQtK/Jh8jwViprrEpHmLmCFsbYkn
	7y6wQlyqILHj7GtGiBusJJ4297FD1IhLTHrwEOwDCYEzHBLH9q5khlgmIPFt8iEWSFDISmw6
	wAwxR1Li4IobLBMYJWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95Pzc
	TYzAZHL637MJOxjvHbA+xCjAwajEw+vA5h4ixJpYVlyZe4jRFOiiicxSosn5wJSVVxJvaGxm
	ZGFqYmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpz+SXLRXX/mcj06
	MPOQlaHj2qhfuoJynDODmnfOvjrZ8uKBBenTYvubblmKu+WvsL3YvtuqZUWo0ZXZbRfvcP9r
	ZFzWXerLfcyQM+W7yEbdkL2lVzyP8v02nPZm14UO5rX/JQ2eWQqua15zcYe3F6ci78PvXkwC
	Ts4tq28V7NKdes+4yraMX4mlOCPRUIu5qDgRAOdAWoMhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jQd3z/e4hBk9bRS3+TjrGbvFwZz+L
	xYEXC1ks5s6exGjRu+Aqm8X9r0cZLTovdLBabHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBY3
	prewWnQsY7RYtesPo8XNZ9uZHAQ8Wpp72Dx+/5rE6PFk00VGj3+H+5k8Jp7V9dg56y67x51r
	e9g8Ni+p9+htfsfm0bdlFaPH501yAdxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUDvKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEy
	QAMJaxgzHnVcYixYJVIx52cHawPjZoEuRk4OCQETiRdtZ9khbDGJC/fWs3UxcnEICUxnlNg1
	8SQThPOXUeLI6dlsIFVsAroST97PZQaxRQTUJG7umcUEYjML9DJL/HvJCGILCWRLvPq3EizO
	CVR//8JKsF5hgTCJ66vvs4DYLAKqEu+fzwHbzCtgKdHUM4kRwhaU+DH5HgvETHWJSfMWMUPY
	2hJP3l1ghbhUQWLH2deMEDdYSTxt7mOHqBGXmPTgIfsERqFZSEbNQjJqFpJRs5C0LGBkWcUo
	mlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnKyeSe1gXNlgcYhRgINRiYfXgc09RIg1say4MvcQ
	owQHs5IIr1I9UIg3JbGyKrUoP76oNCe1+BCjKdCnE5mlRJPzgYk0ryTe0NjE3NTY1NLEwsTM
	Ukmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QDo/shOcvbR57sbrglJB8QF8JTeukG58KQ9l+s
	p3hLJNiVvzeuWfaeWWl/+fmQxRdEQ+dNnHZzw3EO+as2rCe0+OYKLtPMWrrP2JxTY8pjX+3g
	e3ouS/XKPVWmntnhV+KWw2G7/9+zq1uCMyvlpiz8dUq0wtU+aebMzDinzY7Hz7a+PvUrXmWX
	pxJLcUaioRZzUXEiAA6Iq+hsAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On Tuesday, October 07, 2014 2:39 PM, Lee Jones wrote,
> On Tue, 30 Sep 2014, Pankaj Dubey wrote:
> 
> > Currently a syscon entity can be only registered directly through a
> > platform device that binds to a dedicated syscon driver. However in
> > certain use cases it is desirable to make a device used with another
> > driver a syscon interface provider.
> >
> > For example, certain SoCs (e.g. Exynos) contain system controller
> > blocks which perform various functions such as power domain control,
> > CPU power management, low power mode control, but in addition contain
> > certain IP integration glue, such as various signal masks, coprocessor
> > power control, etc. In such case, there is a need to have a dedicated
> > driver for such system controller but also share registers with other
> > drivers. The latter is where the syscon interface is helpful.
> >
> > In case of DT based platforms, this patch decouples syscon object from
> > syscon platform driver, and allows to create syscon objects first time
> > when it is required by calling of syscon_regmap_lookup_by APIs and
> > keep a list of such syscon objects along with syscon provider
> > device_nodes and regmap handles.
> >
> > For non-DT based platforms, this patch keeps syscon platform driver
> > structure so that syscon can be probed and such non-DT based drivers
> > can use syscon_regmap_lookup_by_pdev API and access regmap handles.
> > Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> > we can completely remove platform driver of syscon, and keep only
> > helper functions to get regmap handles.
> >
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> > Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> > Tested-by: Heiko Stuebner <heiko@sntech.de>
> > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> 
> Applied for v3.19.

I can't see this in 3.18-rc1, as this patch is one of dependency for many of Exynos PMU related patches,
will you please queue this patch for 3.18-rc2, so that already ready to be in patches having this patch as
dependency can be taken in.

Thanks,
Pankaj Dubey
> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead Linaro.org │ Open source software
> for ARM SoCs Follow Linaro: Facebook | Twitter | Blog

