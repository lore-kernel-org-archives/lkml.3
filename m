Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3LNNYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:24:33 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40588 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab3LNNYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:24:31 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Alex Ling <kasimling@gmail.com>
Cc: ben-linux@fluff.org, kgene.kim@samsung.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ARM: dts: Add missing clocks for exynos4412 dwmmc node
Date: Sat, 14 Dec 2013 14:24:23 +0100
Message-ID: <6057819.pWzq25qpVf@flatron>
User-Agent: KMail/4.11.4 (Linux/3.12.2-gentoo; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1386998490-19456-1-git-send-email-kasimling@gmail.com>
References: <1386998490-19456-1-git-send-email-kasimling@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Saturday 14 of December 2013 13:21:30 Alex Ling wrote:
> This patch adds "biu" and "ciu" clocks for exynos4412 dwmmc
> node. Without this patch, dwmmc host driver will skip enabling the
> two clocks and it will break dwmmc host function on exynos4412.
> Tested on FriendlyARM TINY4412 board.
> 
> Signed-off-by: Alex Ling <kasimling@gmail.com>
> ---
> Changes for v2:
>    - Fix patch description as Mark Rutland suggested
> 
>  arch/arm/boot/dts/exynos4412.dtsi |    2 ++
>  1 file changed, 2 insertions(+)

The patch is correct, but unfortunately it's not the only thing that
is wrong with MSHC device tree node for Exynos4x12.

Please refer to my series fixing DW-MSHC support on Exynos4x12 (and
enabling it on TRATS2 board):
http://www.spinics.net/lists/arm-kernel/msg293652.html

Best regards,
Tomasz

