Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaK0NIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:08:50 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13267 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaK0NIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:08:48 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-76-5477225c3615
Message-id: <1417093723.32141.1.camel@AMDC1943>
Subject: Re: [PATCH v4 1/7] mfd: max77686/802: Remove support for board files
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 27 Nov 2014 14:08:43 +0100
In-reply-to: <20141127130301.GX7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-2-git-send-email-k.kozlowski@samsung.com>
 <20141127130301.GX7712@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xK7qxSuUhBnf8LDbOWM9qMfXhEzaL
	+UfOsVr0P37NbHG26Q27xf2vRxktvl3pYLLY9Pgaq8XlXXPYLGac38dksfbIXXYHbo+ds+6y
	e2xa1cnmcefaHjaPzUvqPfq2rGL0+LxJLoAtissmJTUnsyy1SN8ugSvj+pO9jAVfWCq2/FzM
	2sD4ibmLkZNDQsBE4sqxt1C2mMSFe+vZuhi5OIQEljJKfO/ZzA7hfGaUaDy8lw2kildAX+JL
	3w9GEFtYwFfi+7/HTCA2m4CxxOblS8BqRASUJa5+38sC0sws0Mws8e/BP1aQBIuAqsT+SxDN
	nAJGEhcOdTJBbFjLKPHp2yewBLOAusSkeYuAbuIAuklZorHfDWKxoMSPyfdYIErkJTavecs8
	gVFgFpKOWUjKZiEpW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJC6+7mBceszqEKMA
	B6MSDy/DrbIQIdbEsuLK3EOMEhzMSiK8XIzlIUK8KYmVValF+fFFpTmpxYcYmTg4pRoYz/16
	XGn3/3qrl7LvQZ3VDclVu3LT1186miMmptjqca3mXWdf+rR9GstWT1C8FeO4y/LO7m2VXd3b
	Eie/z1Zq2BDyavH/J19lXxr+flYueChkwhOpU7sLNmVzr/myVWf6IbkMqdTJmxfJt3jZT+ss
	+jGBv0TNs4x963URlaP9PclLmjJTyh+pK7EUZyQaajEXFScCABlNmPBpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 13:03 +0000, Mark Brown wrote:
> On Thu, Nov 27, 2014 at 12:20:47PM +0100, Krzysztof Kozlowski wrote:
> > The driver is used only on Exynos based boards with DTS support.
> > After removal of board file support from max77686 and max77802 regulator
> > drivers, the MFD driver can be converted to DTS-only version. This
> > simplifies a little the code:
> 
> Why is this a dependency for new features in the regulator core?
My mistake, I based this patchset on regulator cleanup but this MFD
change is not needed for it. It can be skipped here. Sorry for the
noise.

Best regards,
Krzysztof

