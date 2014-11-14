Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935337AbaKNPGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:06:23 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:50112 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbaKNPGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:06:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>, patches@apm.com, linux-kernel@vger.kernel.org,
        =devicetree@vger.kernel.org
Subject: Re: [PATCH V2 4/7] arm64: dts: Add Designware GPIO dts binding to APM X-Gene platform
Date: Fri, 14 Nov 2014 16:06:15 +0100
Message-ID: <1829495.FoDfH1G36W@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415924401-3013-5-git-send-email-fkan@apm.com>
References: <1415924401-3013-1-git-send-email-fkan@apm.com> <1415924401-3013-5-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lG+56G5dsWb7+w3Dr7LKgdfPzDtpxErvMxjNCq+mC72
 aYOkySD0dXPfjoi3Cz9QLDpf2KO/qs8Bl/PkRE6Jixy841zlyH
 SI4xn4Xk41GCSIys+uwP1zKVNbWxj0jaT5Q0gqDOXBWYdXtV9K
 fxjy5CTHN04tSzb40LPvMc+9/dvtfLIia0PRjiCpkZ63kyTJmK
 xqrGgZvEhUUvRJ9mrNH2M1l40Ey6w7L+WENNAfrg+fM3eR2IrO
 jQ9qFcXLoEL7mqAr3rPB1fgyaPvXtPhuCmT6JFq58DlfKNRPlR
 BFUE0ciLMOrw5lIcd7nxG+Ma+8RKpBbVdQLb/ZCYLHYilw5D0S
 Y6FY1Du/lAAfqHmRtvPk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014 16:19:58 Feng Kan wrote:
> +               dwgpio: dwgpio@1c024000 {
> +                       compatible = "snps,dw-apb-gpio";
> +                       reg = <0x0 0x1c024000 0x0 0x1000>;
> +                       reg-io-width = <4>;
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> 

Same comment as patch 1: make the node name 'gpio', not 'dwgpio'.

	Arnd
