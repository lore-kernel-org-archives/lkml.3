Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaBLQy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:54:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51854 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaBLQyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:54:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] ARM: Delete asm/system.h
Date: Wed, 12 Feb 2014 17:54:42 +0100
Message-ID: <1559240.V3DW7mAybD@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140212154615.2405.88996.stgit@warthog.procyon.org.uk>
References: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk> <20140212154615.2405.88996.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:N3yUE+vOiFYMsrZZBMBy6ZqcxN2zwA0H8igqGgPnTtQ
 fYP5/pp5Z+Qe2LQBYgGUW53Ofiec1AxwwEZakBL63dnn+0DZQF
 h2ViOu+lWWmDxB4ev7cm43p79XoUBgN7XKfGq9pKDo4tnIYJxN
 ek+YD6AM2phMugQFv3S2hOeLR9kQRexVlPAyVY5YRn5tKfNM51
 b5zmLshDfN0rKKrYv+3aHPM3+IDWKt48OE7b33gLlqblhG4J9M
 t4/XthzbIjJLdjcLw0nacrhFaHSC7v1a7E8SYJJM+i7jm3GyFI
 AescBL7DO4reXna6W4okl36GQsSmLAwisPLanseuHry1TVy/0u
 IayFzHkihzZBJPV8IhIk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 February 2014 15:46:15 David Howells wrote:
> Delete ARM's asm/system.h.  It's the last holdout and should be got rid of.
> 
> This builds for defconfig, lpc32xx_defconfig, exynos_defconfig + XEN, the
> previous changed to a Gemini system and an omap3 config with TI_DAVINCI_EMAC.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Russell King <linux@arm.linux.org.uk>
> cc: linux-arm-kernel@lists.infradead.org

Acked-by: Arnd Bergmann <arnd@arndb.de>

I've added this to my randconfig builder, will let you know when unexpected
bugs show up (probably won't).

	Arnd
