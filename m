Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaBXOfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:35:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:62134 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaBXOf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:35:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2] arm/smp: Absorb boot_secondary()
Date: Mon, 24 Feb 2014 15:35:13 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
References: <1393247328-23163-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1393247328-23163-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402241535.13873.arnd@arndb.de>
X-Provags-ID: V02:K0:ummbQODSeI+atsftQ1Lm2IbERNePDuVl0S3qEcGdYj+
 zF+n9PZY86XjvoGoCnYSYc5k+aWGM4Z3N3qi8+D3M52mICZ7El
 bhUxuIMjYPz1jUWMM30kKBiLr470nwcHRm05I2KjOCleUWtZ6f
 YR3Yw6zjZVu62xUqAmmPM77IuqpXtjZEgdwH4xU6SiHyx5Bg8r
 Bfa1E/ThqhEc3dd404M/IrWlzUfBLuuxKqRjUlm6VNWtdvKH2P
 GeMD0JAt5Ipa8NHtlwQRnzmDmb3aBOjJ9hPggmOaZZ0vB1C+F6
 QtNmV5rIQ6mO7qpaac4c6VqmlhxI/aX60YQzV5bLrPd+KW1Zif
 eagfBx94uig5H++mWDa8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 February 2014, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> After becoming a mandatory function, boot_secondary() is no longer used
> outside arch/arm/kernel/smp.c. Hence remove its public prototype, and,
> as suggested by Arnd, let it be absorbed by its single caller.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
