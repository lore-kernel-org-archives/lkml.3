Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaLJLBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:01:35 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:55485 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaLJLBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:01:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        srv_heupstream@mediatek.com, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@linaro.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>, yh.chen@mediatek.com
Subject: Re: [PATCH 2/4] irqchip: mediatek: Add support for mt8173
Date: Wed, 10 Dec 2014 12:00:38 +0100
Message-ID: <2545975.QDuBFbG7BN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418208602-35584-3-git-send-email-eddie.huang@mediatek.com>
References: <1418208602-35584-1-git-send-email-eddie.huang@mediatek.com> <1418208602-35584-3-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Q07EoDcINIQtgobyCjlkARjKwl3Fx2OUSfZX6BLkAdUXO9END3d
 4MZK7PNXdGQ07cEJmJfJqvN2wtj/sClaxE5SSCaQ+8qmsb9G2HbRu1s8OXOKxzjqCIg5Eyh
 1zG0Fk7Ny9c8gMYjGwDZ2NM4z6fplYOZ0V7UvSGbbz5Q1+mQ6C6ztxzsli2JO/m5hsFlQiV
 coy18mIdSgnvlbxxOMe0A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2014 18:50:00 Eddie Huang wrote:
> From: Yingjoe Chen <yingjoe.chen@mediatek.com>
> 
> MT8173 intpol have 32 more irq pins, add support to it.
> 
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> 

How about adding a property for the number of irq pins and leave the
old compatible string in place? I don't think it would be good if
we have to update this driver for each new SoC that uses this
irqchip just to change one number.

	Arnd
