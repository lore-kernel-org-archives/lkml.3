Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaK0Mgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:36:48 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:54438 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbaK0Mgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:36:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        InKi Dae <inki.dae@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>, geunsik.lim@samsung.com,
        "sw0312.kim" <sw0312.kim@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/19] pinctrl: exynos: Add support for Exynos5433
Date: Thu, 27 Nov 2014 13:36:36 +0100
Message-ID: <4132795.KBVIQFTevx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+Ln22FtvUD1HqH9PCGPCRu8Cyc6u4oNnsrEWyKYODtCT8wKHQ@mail.gmail.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com> <3904347.Bp2gmpYM49@wuerfel> <CA+Ln22FtvUD1HqH9PCGPCRu8Cyc6u4oNnsrEWyKYODtCT8wKHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TIjtzx6k+UJAN9ldTp+yTnk59/pdkZVz2kEVYPFZE+L
 OUnhH/YS2BZNZ1RtXtv8KQzKK/4vYJN1VQCTyMYA/lFeLyW5F9
 8m0+vjBkSZHsNG3Liturg+l4OzEtcLZkAXv+5fsa/wKZnu0p4f
 h2BVnaoxH9x1D11FUuC4s3eNeUsMH4JvmKrAPADFJTCtkf5Ozs
 XS5f4XB3XaQ63CDe8QQ6Mymbdw2XKof6h5gctmqNF/ooC/vXI5
 hrA3F2Rkgukr8mmNo5tb6sOIC8n7pzuh0txV0KaURLO/gRYJjp
 yJCT/Nag6mdgj6S+FlAi3W934LKnXzNcv7AfkOHXzGSn2s2UV5
 zZAqw2o4AjlzKKpKqn2o=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 21:14:59 Tomasz Figa wrote:
> > my impression is that with the
> > move to arm64, you should come up with a new binding that can fully
> > describe each controller so you don't have to add new code and bindings
> > for each future SoC that uses the same scheme.
> 
> Still, this is exactly the same thing I thought when initially refactoring this
> driver 2 years ago and what was dismissed at that time due to people
> supposedly not wanting that much data in DT. If this point of view has changed,
> then I fully support your view, though.

I guess people were at the time underestimating the rate at which Samsung
comes out with new SoC variants that are all slightly different.

	Arnd
