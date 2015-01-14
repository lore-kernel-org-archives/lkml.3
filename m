Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbbANLyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:54:44 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:65019 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbbANLyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:54:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rameshwar Sahu <rsahu@apm.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ddutile@redhat.com,
        jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
Subject: Re: [PATCH v2 1/3] dmaengine: Add support for APM X-Gene SoC DMA engine driver
Date: Wed, 14 Jan 2015 12:54:25 +0100
Message-ID: <2355599.PaLfD1Yyf4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFd313zMoW86ZcXURrk2K+E6129L+BruOp4E0A=w0PQEcMr-Yw@mail.gmail.com>
References: <1420628981-22774-1-git-send-email-rsahu@apm.com> <1701652.4qUlzcU1j2@wuerfel> <CAFd313zMoW86ZcXURrk2K+E6129L+BruOp4E0A=w0PQEcMr-Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:sqI2Q/xXT4SUrQpEAVnSPEmPImVyTVfhaSI1xM4x0E7+ZWHmliJ
 0km6mth1hZhPxJgur+26na37VQtbipNZi1QlMLCqw0wGLTY3EgjgyFRnYJsEULILoaScjxN
 32QSnAqV4MwuVisG9c0WkwZePMT7uXGGgoTcW7lgShDQ6Mbm6NrnWLcZ/xq19+cppw4gAHX
 y1oRAfsMet/CYYd6yyduQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2015 14:56:33 Rameshwar Sahu wrote:
> 
> > Also add the correct dma-ranges property in the parent, or else this will
> > fail in the future once we add proper checks to dma_set_mask.
> 
> I see arch/arm64 kernel doesn't use dma range value parsed from
> dma-range property currently, I will check it more.
> It doesn't use dma_pfn_offset value calculated by the dma-ranges in
> dma mapping API.
> dma-ranges value should test properly before adding.
> Is there any use to add this dma-ranges properly if arch code doesn't support ??

Of course: the dt needs to describe the hardware correctly. This is
just a bug in the current arm64 code and it will soon be fixed.

	Arnd
