Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaJ2IKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:10:20 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:49500 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbaJ2IKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:10:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/4] MIPS: GIC device-tree support
Date: Wed, 29 Oct 2014 09:09:51 +0100
Message-ID: <15750371.2vAOfonLTV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414541562-10076-1-git-send-email-abrestic@chromium.org>
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:R7YR0oTO4+g20hEz/HnY/vb29dE4Wyzf6ayka6W+WgC
 TN1u9+0Q/dh9THxuI1gKZ85Ia+/4JStxAjMa7VDJqM6i9oPsoa
 KGnQ+GKcv0LCZ/7yw0c3hrzfaiJ52cftarn2fWNhAhfy3Bm82w
 LHq+8eNFXo3pwKO2pILtSXKfpPLhCqcjjItVsWMNxt+957ABGN
 2VP6boNmDGiNYJKfk3J5Gtt2Ta82apHnKhHEeYHm+QyoIC7SxU
 Dliiz7q29oSdgEWiJHghFE6kBzGSZigu2DbtnN4hr4dCyjwzGL
 kMw/OY7JXMjLQ2fjm48aSGId6lXmDFUUXGwDAIY2D+jsxYLhvd
 1vq4RQaY+idDpwm9+6+k=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 17:12:38 Andrew Bresticker wrote:
> This series add support for mapping and routing GIC interrupts as well
> as setting up the GIC timer through device-tree.  Patches 1 adds the
> "mti" vendor prefix, patch 2 adds the GIC binding document, and patches
> 3 and 4 add device-tree support for the GIC irqchip and clocksource drivers,
> respectively.
> 
> Based on next-20141028, which includes part 1 [0] and part 2 [1] of my
> GIC cleanup series.
> 

Looks all good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>
