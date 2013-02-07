Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab3BGOUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:20:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab3BGOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:20:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: io: Fix ioread16/32be and iowrite16/32be
Date: Thu, 07 Feb 2013 15:20:15 +0100
Message-ID: <3630909.tYHO9HKPet@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-4-generic; KDE/4.10.0; x86_64; ; )
In-Reply-To: <1360246728-3490-1-git-send-email-michal.simek@xilinx.com>
References: <1360246728-3490-1-git-send-email-michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dVVi9tSSIR06LU2UfdJmx61Jr6kNLIVEw7Yc2Y1CELV
 Kf88E436h/DT14UgD9DgzZAkJg3ENnncm/rhCsqLn23HDM8ZLW
 oDQFYmLam+6gpt4VhEj/RtPwhqcNgvz+J0aCpK5ZrxzK3pmuge
 BGzm6+pOhiCWaOhq4jYNnnabXxvSpMRVzAwQ2OQACvDG1cae+p
 Ktw/ZJtY0fUqRzdRbqGfjka9S1C9qwe3gQ66Pt+uXoVFBRcSHy
 yGBUOv8/ctlvBW28HMx1Cnk/4TvbL2eU4l2LvD6PPphG77qwrt
 SCkKTI1JJ7nbdaMWvT/cu2b+2y2Bvc/M667TEGhjjDtSz3NYga
 qlbMTGn1M3yyzdf7hT7k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013 15:18:48 Michal Simek wrote:
> Fix ioreadXXbe and iowriteXXbe functions which did
> additional little endian conversion on native big endian systems.
> Using be_to_cpu (cpu_to_be) conversions with __raw_read/write
> functions have resolved it.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Will Deacon <will.deacon@arm.com>
> CC: linux-arch@vger.kernel.org

Acked-by: Arnd Bergmann <arnd@arndb.de>
