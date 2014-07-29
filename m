Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaG2Uni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:43:38 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50449 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaG2Unh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:43:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, Addy Ke <addy.ke@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCH 0/5] Add eMMC and SD card support for rk3288-evb
Date: Tue, 29 Jul 2014 22:42:51 +0200
Message-ID: <2167758.ZBctteP0VZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406665916-23396-1-git-send-email-dianders@chromium.org>
References: <1406665916-23396-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qYY4FVeRSYAc2vyhxAolgt3E6+a5RwsgxAFVp5DE402
 zVAHvSnrMfpI3phzgN38y5wA2axxHvcHlZejvVny2LACksXusw
 PfmYqoG6dEml/39K/6tRIOb1AIxGTwgPUlbXPXJDB72ckHzQnP
 fNSk5xX83m8LQOx4AQ/3o6CSQLBFhO6yt1mph/Olv2nPlDH8lY
 3YaSkNdx38x7E4m8pYbYFHGHDROBQoALarRIETOLMZYONkYKmw
 fJOEqAuM74n2brBAEsMeTS9CbNxHdMnNN+TDHsyXbuGPYvBynh
 EQdcAm8gS/9cfXBEN4lxmdlDdldcft4Ut/CQSaaiVzjtFatV3t
 SIJzMPvqWXM4cxbyjWJw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2014 13:31:51 Doug Anderson wrote:
> This series adds basic eMMC and SD card support for the rk3288-evb
> board based on Addy's posted dw_mmc patch from:
>   https://patchwork.kernel.org/patch/4520631/
> 
> The series is a little tricky because:
> * Addy's patch has a bug w/ DDR50 (see my response there), so I've
>   posted the original support without DDR50 and then a fix (that could
>   be squashed) enabling DDR50.
> * Jaehoon has some outstanding patches to remove the slot node.  Since
>   those haven't landed yet, I've posted my original patch with the
>   slot node and then some future patches that can land with Jaehoon's
>   patches.
> 
> Note that we don't have regulators specified yet (no regulator driver
> for rk808-based board).  We also don't yet support UHS modes (which
> require regulator support plus dw_mmc driver support for tuning).
> Those features can come later.

Looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>

I wonder whether something can be done to generalize the tuning
support. Is this just about the clock phase, or something else?

	Arnd
