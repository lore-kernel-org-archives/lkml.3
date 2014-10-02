Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaJBJZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:25:13 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54683 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJBJZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:25:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Victor Wan <victor.wan@amlogic.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Carlo Caione <carlo@caione.org>,
        Jerry Cao <jerry.cao@amlogic.com>
Subject: Re: [PATCH 1/6] ARM: meson: add meson8 machine definition
Date: Thu, 02 Oct 2014 11:24:54 +0200
Message-ID: <11073411.IcmTkIICYA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412198986-26534-2-git-send-email-b.galvani@gmail.com>
References: <1412198986-26534-1-git-send-email-b.galvani@gmail.com> <1412198986-26534-2-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:M3xBfPXhYcDv/+Nw++nWdhlxbzyS5ZhmG+1OfFFWwvU
 zQbvFdNEsXBF8YFWtWp6qBF4pSrXWd8EdSHgc9uQDRoHalhZt2
 ty5poi8vEKZz7nFaDkpTz6cmbSNKB7MNG0BX+tMfOyGHilj3dj
 d3rD8xKX9JXeprlFJfbh4dLXcJ2Goz1aSsdGdB2PbpijRFD17U
 Q8zxCNGoNqphMAP11ilIgAUGJqst645Z7d790Eg02E9Nrp2Glt
 +NXQAZ96HfK4utepr06/1IqM/v/2+RCYesR25GSQ7dmSQm7kuv
 lPCaFKPUVyHgAqIFKjydjestUC5sOIiaGQHOmS8Pjo5WczHGE6
 VHzqNL6kS/q9fyI5K1/4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 23:29:41 Beniamino Galvani wrote:
> 
> +static const char * const m8_common_board_compat[] = {
> +       "amlogic,meson8",
> +       NULL,
> +};
> +
>  DT_MACHINE_START(AML8726_MX, "Amlogic Meson6 platform")
>         .dt_compat      = m6_common_board_compat,
>  MACHINE_END
>  
> +DT_MACHINE_START(MESON8, "Amlogic Meson8 platform")
> +       .dt_compat      = m8_common_board_compat,
> +MACHINE_END
> 

I'd just add the meson8 string to the m6_common_board_compat list and
rename it.

	Arnd
