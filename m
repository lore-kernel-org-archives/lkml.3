Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3ARPGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:06:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab3ARPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:06:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 71/76] ARC: [Review] Multi-platform image #4: Isolate platform headers
Date: Fri, 18 Jan 2013 15:06:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-72-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-72-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181506.31438.arnd@arndb.de>
X-Provags-ID: V02:K0:SecRGwHQU/b+pOqUDBeLYtpifBhNDKoofPFqZkbiyK0
 0gDupHAxH+Z1F3uEqDRe7iGScfz/yX6JrcjKs0dpVUdyg0Ksnw
 NXdxTx06lVCWhk8Mse1XI40jpLlv7uXXPHPI9gUDClmFreGIPK
 4RTaG8BxahbUcob2VhTLETKOJCneRspc6PHoWxXUjOn49Sr3QZ
 RKQ0TlHS035nWdFbF35U+iPG/MjsUwmVg2Br1bQL6a50xpcx2O
 T1SQrV4pTvyyMq3aaAKkR4TIO2Jg8cL0UcR+yvKHq2Hah5eCQy
 5+Sx8cCqH0KpGDUUokwPwhzjCayGC0vBKPqY6sIclVtlVxUi31
 WFZo3l6sguPOD+Wxy9MU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> -Top level ARC makefile removes -I for platform headers
> -asm/irq.h no longer includes plat/irq.h
> 
> -platform makefile adds -I for it's specfic platform headers
> -platform code to directly include it's plat/irq.h
> 
> -Linker script needed plat/memmap.h for CCM info, already in .config
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
