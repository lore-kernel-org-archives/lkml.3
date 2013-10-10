Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3JJLko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:40:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13710 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab3JJLkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:40:41 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-03-525692372752
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
 <05c701cec56f$b79eea50$26dcbef0$%dae@samsung.com>
 <20131010093708.GC21581@sirena.org.uk>
In-reply-to: <20131010093708.GC21581@sirena.org.uk>
Subject: RE: [PATCH 3/5] drm/bridge: Add PTN3460 bridge driver
Date: Thu, 10 Oct 2013 20:40:38 +0900
Message-id: <063a01cec5ad$8afd1920$a0f74b60$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7FnFHnZYzl5v3KSYeK3g3NxshyLAADKopg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsWyRsSkRNd8UliQwYIlihZTHz5hs5h/5Byr
	xZWv79ksNj2+xmqxsG0Ji8XlXXPYLGac38dkcer6ZzaLuxvOMjpwesxuuMjisWlVJ5vH/e7j
	TB6bl9R7XDnRxOrxeZNcAFsUl01Kak5mWWqRvl0CV8b/pRMZC1byVOy4d56tgfETZxcjJ4eE
	gInE9e07WSBsMYkL99azdTFycQgJLGWUWNn2hRWm6Pn9dawQiUWMEgfmPWOGcH4zSjTdmcoI
	UsUmoCoxccV9oHYODhEg+/8rd5Aws8AyJomnc2JBbCGBVywSW/eXgNicAsYSF5ZtBtssLGAn
	se/CTxaQVhaQMW8VQMK8ArYSi991M0HYghI/Jt9jgRipJbF+53EmCFteYvOat8wgrRIC6hKP
	/uqChEUEjCRuzlrGDFEiIrHvxTtGkIslBFo5JHZMOgnWyyIgIPFt8iEWiF5ZiU0HmCHelZQ4
	uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMwrk//
	ezZhB+O9A9aHGJOB1k9klhJNzgemhbySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MEZGTToq6j/7VNHa3Vz8yUFsIsGKrtLFX5bWPM3a9jDxsfPC
	AxcmRW6Tt17sM3/Wj9LHnveqGS/obksxfN1hNNl0vafeT/3c5BZulVg1TcFneuKGla5XX+3r
	Dj0S3MPv7ae5eO3fyX9KTN6s2y/aF57rZRZrdKpcqKTuhfOk3x5ejV0f8709lViKMxINtZiL
	ihMBiTFfoAEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAV3zSWFBBo/fSlhMffiEzWL+kXOs
	Fle+vmez2PT4GqvFwrYlLBaXd81hs5hxfh+Txanrn9ks7m44y+jA6TG74SKLx6ZVnWwe97uP
	M3lsXlLvceVEE6vH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	/i+dyFiwkqdix73zbA2Mnzi7GDk5JARMJJ7fX8cKYYtJXLi3nq2LkYtDSGARo8SBec+YIZzf
	jBJNd6YyglSxCahKTFxxH6iKg0MEyP7/yh0kzCywjEni6ZxYEFtI4BWLxNb9JSA2p4CxxIVl
	m1lAbGEBO4l9F36ygLSygIx5qwAS5hWwlVj8rpsJwhaU+DH5HgvESC2J9TuPM0HY8hKb17xl
	BmmVEFCXePRXFyQsImAkcXPWMmaIEhGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjBSeOZ1A7GlQ0WhxgFOBiVeHgrykKDhFgTy4orcw8xSnAw
	K4nwzikPCxLiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGBCyyuJNzQ2MTOyNDI3tDAyNidN
	WEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxpM+x6q3nalROxTIfcZ6Fuu/Vzwr9M+sMEhM
	+CPF6HYyy+jemoz71dPOWEc8Zv9SNLtgZbqSna21SQKbyqXuCRd/5Yoelb/U8tn95ePETzqs
	TFpTw1fKLPnjFrN1Ub/r/opvW27eu9NtJftlSdsEo7istLt/9r+TmsAm9qpk1fU/yla3voYd
	1VdiKc5INNRiLipOBABmPIJFXgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Thursday, October 10, 2013 6:37 PM
> To: Inki Dae
> Cc: 'Olof Johansson'; 'Sean Paul'; devicetree@vger.kernel.org; linux-
> samsung-soc@vger.kernel.org; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org; 'DRI mailing list'; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH 3/5] drm/bridge: Add PTN3460 bridge driver
> 
> On Thu, Oct 10, 2013 at 01:18:05PM +0900, Inki Dae wrote:
> 
> > > > I still think the pin could be replaced with a regulator. But
> > > > lvds-bridge node has "powerdown-gpio" property - it say this board
> > > > will use gpio pin - specific to board.  So it seems no problem.
> 
> > > No, don't model things that aren't regulators as regulators - it's
> > > just confusing from a usability standpoint and causes breakage when
> > > the pins don't behave like regulators.
> 
> > It seems that there was your missing point. That _is not_ what I
> mentioned.
> > I mean that other boards can use a regulator instead of gpio pin.
> 
> What I'm saying is no boards should use a regulator to control that GPIO
> pin, obviously if they're controlling the actual regulators that's fine

That is what I mentioned. Some boards _could control_ the actual regulator
for lvds-bridge, and that would be depended on how HW engineer designs the
board. 

> but the reset signal should not be controlled via the regulator API (there
> are some unfortunate cases where people have done that already but let's
> not have any more).

