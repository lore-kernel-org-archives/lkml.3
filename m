Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935214AbaKNPE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:04:56 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51089 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbaKNPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:04:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>, patches@apm.com, linux-kernel@vger.kernel.org,
        =devicetree@vger.kernel.org, Bao Truong <btruong@apm.com>
Subject: Re: [PATCH V2 1/7] arm64: dts: Add APM X-Gene USB DTS node
Date: Fri, 14 Nov 2014 16:04:45 +0100
Message-ID: <2126031.OOHBs2pzVu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415924401-3013-2-git-send-email-fkan@apm.com>
References: <1415924401-3013-1-git-send-email-fkan@apm.com> <1415924401-3013-2-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+OGh6mIORxsQLdEjkBKu7RIcaImx74mTJV0w7BbpCUY
 mUEpfqpFzpLC9nyJYRDL0b38FmYeWpItJ6JObpGQeCapO0SVYn
 ZKUH8+dh6wHNxv4X70EPLv6Nj4KojZk283osHyXrmQaRLJtOqt
 tJWupFjstVvmriskSRutZlgBOly8wicghAqf2+Pk6J7GY2eZke
 YZgj1/NRwApONITi64TnFvKa94ra/pKvN6VWgCfZJnE6JzL7qM
 KX56nALTUjZERVaDCptM2Hq8hDTKz3F3DhBnm9gy0LloSzBw+C
 mJPpVJNBM31jPngfxrFyCMYQ1p5EHjSR319Pbw3VjYRv7dMDTy
 DqO2Ogs3oLFM65NvTYvo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014 16:19:55 Feng Kan wrote:
> 
> +               usb0: dwusb@19000000 {
> +                       status = "disabled";
> +                       compatible = "xhci-platform";
> +                       reg =  <0x0 0x19000000 0x0 0x100000>;
> +                       interrupts = <0x0 0x89 0x4>;
> +                       dma-coherent;
> +               };
> +
> +               usb1: dwusb@19800000 {
> +                       status = "disabled";
> +                       compatible = "xhci-platform";
> +                       reg =  <0x0 0x19800000 0x0 0x100000>;
> +                       interrupts = <0x0 0x8a 0x4>;
> +                       dma-coherent;
> +               };
> 

Call the nodes 'usb', not 'dwusb'. Should these be 'status="disabled"', or
do you expect every machine to have both connected?

	Arnd
