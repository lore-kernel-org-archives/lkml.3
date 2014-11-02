Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaKBMYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 07:24:39 -0500
Received: from gloria.sntech.de ([95.129.55.99]:42579 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaKBMYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 07:24:38 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: rockchip: add serial aliases for rk3066 and rk3188
Date: Sun, 02 Nov 2014 13:27:44 +0100
Message-ID: <1556322.3CdNOEchaI@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1414684277-17248-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1414684277-17248-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 30. Oktober 2014, 16:51:17 schrieb Julien CHAUVEAU:
> Add aliases for UARTs on rk3066 and rk3188 in order to fix the numbering
> scheme. This will keep the debug console on ttyS2 when UART 1 is disabled,
> for example.
> 
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>

applied to my dts branch for 3.19

