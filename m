Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3K2AN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:13:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43572 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3K2ANY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:13:24 -0500
X-AuditID: cbfee691-b7f666d0000048b0-c3-5297dc22490e
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-4-git-send-email-k.kozlowski@samsung.com>
 <20131128134757.GJ27568@sirena.org.uk>
In-reply-to: <20131128134757.GJ27568@sirena.org.uk>
Subject: RE: [PATCH v2 3/5] rtc: s5m: Limit endless loop waiting for register
 update
Date: Fri, 29 Nov 2013 09:13:24 +0900
Message-id: <05c901ceec97$d1ca3570$755ea050$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIn7cDk689h23sBcLg83vR3zAVxUwGDjWymAWe/5l2Zcfl80A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+Zga7SnelBBk331SyWXLzKbjH14RM2
	i2e39jJZvH5haHG26Q27xf2vRxktvl3pYLK4vGsOm8XaI3fZLfZ3djBanO5mdeD22DnrLrvH
	nokn2Tw2repk87hzbQ+bx6HDHYwe804GevRtWcXoMX3eTyaPz5vkAjijuGxSUnMyy1KL9O0S
	uDIa1t1mLvjDVLH62zTWBsb1TF2MnBwSAiYSWyZ/Z4OwxSQu3FsPZHNxCAksY5S41rucEabo
	zMqTLBCJRYwSs6ctYodw/jBKzFh5HWwUm4CGxMrdb8FGiQhESEw+ehCsiFngLZPEwuYJzBAd
	6xglHr+5BjSXg4NTwFhiQ4crSIOwQJhE67ZvrCA2i4CqxPbjR8FW8wpYSvzuO80GYQtK/Jh8
	jwXEZhbQkli/8zgThC0vsXnNW2aIUxUkdpx9zQhxhJPEnOZ1rBA1IhL7XrxjBLlBQmAph0Tj
	lIksEMsEJL5NPsQCco+EgKzEpgNQcyQlDq64wTKBUWIWktWzkKyehWT1LCQrFjCyrGIUTS1I
	LihOSi8y1StOzC0uzUvXS87P3cQISQYTdzDeP2B9iDEZaP1EZinR5HxgMskriTc0NjOyMDUx
	NTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk4pYHzr7Y+ds8x0hd4r5cMa
	Gw9IH1ltsyp75nutPV/eOcR9sc2ZPVNu1WlpvacMZuUv9mvWz+Od1yrQetM+QSqtSbD3+It3
	77Tu5IdZsq5xOXLPb2LbyoqWqOtPFxSfs4/MYOL5wSsgUGD+4/LViL+L3E5t8de0ey8oYWNj
	7s361LFc6IB54PWe50osxRmJhlrMRcWJAAsFipYcAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsVy+t9jAV2lO9ODDBovKFosuXiV3WLqwyds
	Fs9u7WWyeP3C0OJs0xt2i/tfjzJafLvSwWRxedccNou1R+6yW+zv7GC0ON3N6sDtsXPWXXaP
	PRNPsnlsWtXJ5nHn2h42j0OHOxg95p0M9OjbsorRY/q8n0wenzfJBXBGNTDaZKQmpqQWKaTm
	JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
	wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMaFh3m7ngD1PF6m/TWBsY1zN1MXJySAiYSJxZeZIF
	whaTuHBvPVsXIxeHkMAiRonZ0xaxQzh/GCVmrLwO1sEmoCGxcvdbNhBbRCBCYvLRg2BFzAJv
	mSQWNk9ghuhYxyjx+M01xi5GDg5OAWOJDR2uIA3CAmESrdu+sYLYLAKqEtuPH2UEsXkFLCV+
	951mg7AFJX5Mvgd2ErOAlsT6nceZIGx5ic1r3jJDnKogsePsa0aII5wk5jSvY4WoEZHY9+Id
	4wRGoVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcap5J7WBc
	2WBxiFGAg1GJh3dF9/QgIdbEsuLK3EOMEhzMSiK8v4qAQrwpiZVVqUX58UWlOanFhxiTgT6d
	yCwlmpwPTIN5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cDo
	aGast00/PdztgJaxgahgw/77u8zSY30KQidsfbTe7w17AcvUc++7d949Laf5/qxMSEzgPp3w
	0m3N30LXi65ad/Wr94pH/cKp59t16w8HvpnVmnm1/2v0i72sKyUiZWyf8Qqsen0jZ0f2DK9W
	Ie+Fny7dfHxEiceLf8r/LWn6lXbFvx6JnLurxFKckWioxVxUnAgAuUK2GXkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 10:48 PM, Mark Brown wrote:
> > After setting alarm or time the driver is waiting for UDR register to be
> > cleared indicating that registers data have been transferred.
> >
> > Limit the endless loop to only 5 retries.
> 
> Reviwed-by: Mark Brown <broonie@linaro.org>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

