Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbaJUT5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:57:50 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53337 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbaJUT5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:57:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, "Franklin Cooper Jr." <fcooper@ti.com>
Subject: Re: [PATCH] ARM: dts: DRA7: Add aliases for all serial ports
Date: Tue, 21 Oct 2014 21:57:35 +0200
Message-ID: <3461773.MMIsJQMVIu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413908295-699-1-git-send-email-nm@ti.com>
References: <1413908295-699-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:futqVkXYAkYuS+blcp5Tww4IZoufILwfKSQHAdYCQcg
 uiJ1i3TFF0sTGoGxu7IDz8J03XIihHK1UhIQ6xtGpI4vJi1N16
 1L/bfSYt4pHM7i4GnjYCMMKi37MW6+tUYx8390Xu2IpPGgc09j
 1IAmTHnmMsz9VNmp4+gwaV/T6Y1FlMhftD39oY94zO+SSZ8K3W
 hKZylP9wON4p6gjBrWgHWzo8TjJVgfcaZEMQaof2ZB03cSjQ8X
 v68irnSDQj54izw+AkMZDwN/VqUPmsnrWl5N38xwFPkHl7xPC3
 YxvDSUocSWXvfz4lMBXkBQ97haiPTVb/llIsAhcMwBguIEyp3H
 j+woh1lkdgbsuKtJmhFI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2014 11:18:15 Nishanth Menon wrote:
> Add serial port aliases for consoles > 6.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  arch/arm/boot/dts/dra7.dtsi |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 9cc9843..208dd83 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -34,6 +34,10 @@
>                 serial3 = &uart4;
>                 serial4 = &uart5;
>                 serial5 = &uart6;
> +               serial6 = &uart7;
> +               serial7 = &uart8;
> +               serial8 = &uart9;
> +               serial9 = &uart10;
> 

I think this was wrong to start with: The aliases should be in the per-board
.dts file and only list the ones that are actually connected to the outside.

Otherwise the numbering won't match what's written on the board.

	Arnd
