Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3AUUKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:10:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3AUUKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:10:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <rob@ti.com>
Subject: Re: [PATCH 15/15] staging/omapdrm: don't build on multiplatform
Date: Mon, 21 Jan 2013 20:09:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <201301211741.11875.arnd@arndb.de> <50FD8B63.1060506@ti.com>
In-Reply-To: <50FD8B63.1060506@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212009.58198.arnd@arndb.de>
X-Provags-ID: V02:K0:15QUiyFjuVoC55nTVkMA40tNtlB4NvuCASy4VvSzbb/
 tlm7abB0pPtAPVPXkGplUo7bDUfmjmAtdPakWGLSVMjVhy2pzU
 euDOa/7qg9D2z8G/peYsiMHDFOLLVvf/0d5PYs8Yb+6rg4tTi4
 TwFiVFmJG2g/ODkj6HRma37Sqn+KEqEPlzz/Ss7s2GNSU4Klgx
 ZVKUD0p2rRoFo5Yl8UcdUOdgtCxzbGyJ9crM51lcc5Ay2OPJSL
 oYFpfqcyOrr0XpC1Dfi26PM7fGs9RaiClB/ryfKR1SzAHn0U23
 4WfWY1X0lgw/mlrWSLDw518rsKvlKlqa3M/brKuR6PVG6NEPb5
 2gB4niGN3gWX2PN46n8Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Rob Clark wrote:
> ahh, ok, I see.. the if ARCH_OMAP2PLUS bit looks like it came in 
> recently (770b6cb)
> 
> what about changing this to 'if ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM'?

Fine with me in general, but the patch I posted would be the more
conservative choice for v3.8.

	Arnd
