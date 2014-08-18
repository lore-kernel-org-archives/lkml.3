Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaHRRmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:42:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63180 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaHRRmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:42:20 -0400
X-AuditID: cbfee61b-f79f86d00000144c-da-53f23af27634
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        t.figa@samsung.com, vikas.sajjan@samsung.com, joshi@samsung.com,
        naushad@samsung.com, thomas.ab@samsung.com, chow.kim@samsung.com
Subject: Re: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
Date: Mon, 18 Aug 2014 19:42:06 +0200
Message-id: <2491338.uD82s4TcKJ@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <002601cfaa11$93de5060$bb9af120$@samsung.com>
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
 <53D238E1.3030901@gmail.com> <002601cfaa11$93de5060$bb9af120$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jQd1PVp+CDZY+YLdYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYtFxzJGi1W7/jBa3Hy2
	ncmB16OluYfNY+esu+wem5fUe/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGgSe7GQu+C1S8
	mNbI3MA4h7eLkZNDQsBE4svulawQtpjEhXvr2boYuTiEBKYzSkz9vhUsISTQwiRx8KchiM0m
	YCUxsX0VI4gtIlAlsW5WJztIA7NAF5PE1bftLCAJYYFQictLl4LZLAKqEtun9oI18ApoSnTM
	Os0GYosKeErs2L4SzOYEGvpz8zt2iM1TGSXm3H7BBtEgKPFj8j2wQcwC8hL79k9lhbC1JNbv
	PM40gVFgFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOD6eSe9gXNVg
	cYhRgINRiYdX4cvHYCHWxLLiytxDjBIczEoivAmmn4KFeFMSK6tSi/Lji0pzUosPMUpzsCiJ
	8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MC5+oWw2fbHfueeMEVEz3fUK9CUfr1iUuWKvnZbt
	te+beW7F/2LN65u6L9VBwXXeXOZXYpdiRBgeJ+mULjjxdP5EuWmygqG3us/8XckSocR+b0H9
	vn0LC+flsNREfpWwLqzpvX3f85LHpOeBol+f55112NO9xozP3PP6RaHHHw9Oe/eo5dSp3hwl
	luKMREMt5qLiRADPHh1tiwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, July 28, 2014 08:40:52 AM Pankaj Dubey wrote:
> Hi Tomasz,
> 
> On Friday, July 25, 2014 Tomasz Figa wrote:
> 
> > To: Pankaj Dubey; 'Kukjin Kim'; linux-arm-kernel@lists.infradead.org;
> linux-
> > samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org
> > Cc: linux@arm.linux.org.uk; t.figa@samsung.com; vikas.sajjan@samsung.com;
> > joshi@samsung.com; naushad@samsung.com; thomas.ab@samsung.com;
> > chow.kim@samsung.com
> > Subject: Re: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for
> > Exynos PMU
> > 
> > Hi Pankaj, Kukjin,
> > 
> > On 25.07.2014 07:32, Pankaj Dubey wrote:
> > > Hi Kukjin,
> > >
> > > On Friday, July 25, 2014 Kukjin Kim wrote:
> > 
> > [snip]
> > 
> > >>>
> > >> Looks good to me, will apply this and 4/4.
> > >>
> > >
> > > We need to hold these two patches until dependent patch [1] from
> > > Tomasz Figa gets merged.
> > >
> > > [1]: mfd: syscon: Decouple syscon interface from syscon devices
> > >       https://lkml.org/lkml/2014/6/24/188
> > 
> > That RFC patch had few comments from Arnd needed to be addressed, so it
> needs a
> > new revision.
> > 
> > Pankaj, If I remember correctly, we had talked about this and the
> conclusion was that
> > you would take care of addressing the comments and sending new version of
> the
> > patch. Any update on this or have I missed something?
> > 
> 
> Well, I don't think we concluded as such anything.
> Since this patch needs to get in so that Exynos PMU and PM related changes
> can go in,
> I discussed with you saying that I am not able to understand about Arnd's
> comments and
> if possible and time permits I will look into it. Meanwhile I got busy with
> some other
> official work, so could not get time to look into it.

Tomasz/Pankaj, could we please get some agreement on what needs to be
done and who should do the pending work?

syscon patch is blocking PMU cleanup patches which in turn are blocking
PMU support additions for new SoCs (Exynos5420/5800 and Exynos3250 PMU
patches).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

