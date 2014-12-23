Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaLWVED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:04:03 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:65099 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbaLWVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:04:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 0/8] ARM: Conexant Digicolor CX92755 SoC support
Date: Tue, 23 Dec 2014 22:03:51 +0100
Message-ID: <5183218.RAoFSdq3OI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1419318109.git.baruch@tkos.co.il>
References: <cover.1419318109.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Z72KTfQF5CtSmMOxdS07y+RwYDudc64E2Ie73HlmPZhLGM2XOhd
 INkayYQz85ahE3sEi44AEFpuB/C1gVCAy00pbRYic+DpxWoqCADP0XPaI3ldYoy2OvKJxZ5
 cyG9ALGyf4CAGjf8fc9aLFFHWCtvdCnFYbRZifPJS+zvWyAoFfF6+ibipnQOVCHT3/d21Xm
 n5sC/ESSqnGLtr9NDxJEQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2014 09:58:37 Baruch Siach wrote:
> This series adds initial support for the Conexant CX92755 SoC. The CX92755 is
> one of the Digicolor series of SoCs, all sharing many of the same peripherals.
> The code was tested on the CX92755 evaluation kit, AKA Equinox.
> 
> Uses attempting to try this code will most likely also want the UART/console
> driver available from https://patchwork.kernel.org/patch/5515861/.
> 

Looks very nice overall!

I have replied to two of the patches, the rest looks fine to me.

	Arnd
