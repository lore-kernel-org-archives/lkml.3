Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaLEKNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:13:36 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57749 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLEKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:13:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Flora Fu <flora.fu@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        arm@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        srv_heupstream@mediatek.com, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Olof Johansson <olof@lixom.net>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Subject: Re: [PATCH v3 1/8] soc: mediatek: Add PMIC wrapper for MT8135 and MT6397 SoC
Date: Fri, 05 Dec 2014 11:13:03 +0100
Message-ID: <2751641.o51TuZRl88@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417752479-4749-2-git-send-email-flora.fu@mediatek.com>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com> <1417752479-4749-2-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:sjiPvxRWeoxIft2k+xeY42q2S7wmL7atMcp/jFlQjbGyL3Xgywv
 W2g3149hszAveC967/cKAm8m3RnhfP6fAz0IzIIa08VViqvoeywiwqaSz3j4ENfdh9BiWlJ
 jMbEj9XkyQHfiQIP6EypwIPYyid3mLTYQM54alGs9qyenDXgi5ipc0OuOn9RXY3/pS6T7oE
 uo7r/PDHcXVT87Z6un5qQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2014 12:07:52 Flora Fu wrote:
> Add PMIC wrapper of MT8135 to access MT6397 MFD.
> 
> Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> 

Please explain what a PMIC wrapper is and why you need one for MT8135.
I don't understand the purpose of this code at all. Is this just another
way of accessing the MT6397 when not using i2c or spi like other
PMIC drivers do?

	Arnd
