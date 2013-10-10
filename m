Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3JJESK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:18:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40797 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3JJESH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:18:07 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-ff-52562a7df567
From: Inki Dae <inki.dae@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Olof Johansson'" <olof@lixom.net>, "'Sean Paul'" <seanpaul@chromium.org>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'DRI mailing list'" <dri-devel@lists.freedesktop.org>,
        linux-arm-kernel@lists.infradead.org
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
 <1380670860-17621-4-git-send-email-seanpaul@chromium.org>
 <CAAQKjZN_r-=-sj=Vb-o-KUS4ab5=cjCq1ni3VZeMeVc3NL=MMg@mail.gmail.com>
 <CAOw6vbLiJLLKn=gb1=j5TBeM0ijEK13+goG-=mw7MZTyNT1kpQ@mail.gmail.com>
 <CAAQKjZPwyKCpju4Ndd+MB_aN24-zA5xTHFsFsun2617h7YT6dw@mail.gmail.com>
 <CAOesGMgKastzdFHYQzyL8gxkBN=86wFZ4jbgP8BHxfkOuZvJxg@mail.gmail.com>
 <CAAQKjZMhovKLxNfnXnbF-6diM2zF1cWyi+xHGyL3v83vBh4p6g@mail.gmail.com>
 <20131009182905.GY21581@sirena.org.uk>
In-reply-to: <20131009182905.GY21581@sirena.org.uk>
Subject: RE: [PATCH 3/5] drm/bridge: Add PTN3460 bridge driver
Date: Thu, 10 Oct 2013 13:18:05 +0900
Message-id: <05c701cec56f$b79eea50$26dcbef0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7FHYU2naHMu2NxTfeJq/b0QYc7XwAUcx8Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsWyRsSkULdWKyzIoPWOksXUh0/YLOYfOcdq
	ceXrezaLTY+vsVosbFvCYnF51xw2ixnn9zFZnLr+mc3i7oazjA6cHrMbLrJ4bFrVyeZxv/s4
	k8fmJfUeV040sXp83iQXwBbFZZOSmpNZllqkb5fAlfGx/QVbwR/Oii3vdjM3MDZwdDFycEgI
	mEg8uyrVxcgJZIpJXLi3nq2LkYtDSGApo8SH/j+MEAkTiYUProLZQgLTGSU+XnKDKPrNKDFn
	2n92kASbgKrExBX32UCGigDZ/1+5g4SZBZYxSTydEwtR38sicbdpDytIglPAWOJVTzNYr7CA
	ncS+Cz9ZQGwWoN6e1xfAbF4BW4n/j54zQtiCEj8m32OBGKolsX7ncSYIW15i85q3zBDPqEs8
	+qsLEhYRMJJYMPcsO0SJiMS+F+8YQW6QEGjkkGg7/Y4JYpeAxLfJh1ggemUlNh1ghvhXUuLg
	ihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjMC4Pv3v
	Wf8OxrsHrA8xJgOtn8gsJZqcD0wLeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGan
	phakFsUXleakFh9iZOLglGpgbE0yMhMqCDh/afLGDYynpkc7rwmc3XPKbkXbGS2ue/3/rE4w
	nf2QHNlySmx3b16m9uXLqxxz9iZHiYsdY6yab3IhazPzB4+cBTdPiXKsebHhrcbc4y3bbpXn
	/3u4OGLnpTV6f1g2eym/b4hjLt8jFRd5p25hYI/PM6vjN70uXX+aymymaZpxTImlOCPRUIu5
	qDgRAI/68IQBAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQd1arbAgg3+XpSymPnzCZjH/yDlW
	iytf37NZbHp8jdViYdsSFovLu+awWcw4v4/J4tT1z2wWdzecZXTg9JjdcJHFY9OqTjaP+93H
	mTw2L6n3uHKiidXj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	H9tfsBX84azY8m43cwNjA0cXIyeHhICJxMIHVxkhbDGJC/fWs4HYQgLTGSU+XnLrYuQCsn8z
	SsyZ9p8dJMEmoCoxccV9oCIODhEg+/8rd5Aws8AyJomnc2Ih6ntZJO427WEFSXAKGEu86mkG
	6xUWsJPYd+EnC4jNAtTb8/oCmM0rYCvx/9FzRghbUOLH5HssEEO1JNbvPM4EYctLbF7zlhlk
	r4SAusSjv7ogYREBI4kFc8+yQ5SISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECE4bz6R3MK5qsDjEKMDBqMTDW1EWGiTEmlhWXJl7iFGCg1lJ
	hHf6SaAQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wNTWl5JvKGxiZmRpZG5oYWRsTlpwkri
	vAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MIpWbslesWoG9/RlzfvjXt3ZG3P0lcB5A1ExRbnz
	nluXBTe6sM0V/v77ZXnW3aSdnHMFWV/PXX74e/z8fjnOzJaGxt8zZy7cHP7WpOSQ9dv33tl/
	nB6wykV8yQwuEXjX5bhTR+fggzqzSe1i/eu+v/fpuMFxhX1H9AfVA/rOjBkZ17nXM3Uqaymx
	FGckGmoxFxUnAgAeRIJ1XwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Thursday, October 10, 2013 3:29 AM
> To: Inki Dae
> Cc: Olof Johansson; Sean Paul; devicetree@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org; DRI mailing list; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH 3/5] drm/bridge: Add PTN3460 bridge driver
> 
> On Fri, Oct 04, 2013 at 11:05:48AM +0900, Inki Dae wrote:
> > 2013/10/4 Olof Johansson <olof@lixom.net>:
> 
> > > "If PD_N is LOW, then the device is in Deep power-down completely,
> > > even if supply rail is ON; for the device to be able to operate, the
> > > PD_N pin must be HIGH."
> 
> > I still think the pin could be replaced with a regulator. But
> > lvds-bridge node has "powerdown-gpio" property - it say this board
> > will use gpio pin - specific to board.  So it seems no problem.
> 
> No, don't model things that aren't regulators as regulators - it's just
> confusing from a usability standpoint and causes breakage when the pins
> don't behave like regulators.

It seems that there was your missing point. That _is not_ what I mentioned.
I mean that other boards can use a regulator instead of gpio pin.




