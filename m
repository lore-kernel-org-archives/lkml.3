Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968329Ab3DSMOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:14:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51556 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968240Ab3DSMOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:14:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] ARM64: kernel: compiling issue: need define readq and writeq for driver module using.
Date: Fri, 19 Apr 2013 14:13:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51712975.8030104@asianux.com>
In-Reply-To: <51712975.8030104@asianux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191413.57424.arnd@arndb.de>
X-Provags-ID: V02:K0:f9QydTEnA5q7MZiQZWnsZC0nrBGp14kfqrMh8RwIWEi
 JqBolJi0pS1jJTa/n8xW7esjqNri7pQ2QgEYptyWuc6OIiltQX
 mu4jrFAUi128fUq5sB9jjyY/hh5u1dgRXXU8l9a0daPhUsClVJ
 jnrC4jyutl788nhoyNmfrZgVOmKasjfWANTssMuMFCQLbJ0Yx9
 ItBKgjA4RffoOOzarqXiKhm8L2cNIVtBco0IUvEkGlF1kCUoPH
 xhMfghgD/bduOFP+top1aO7hBS4Kh+r1hrHRE3GNXTSdWA1Dbd
 L0iHMS0gCRoZ7orwn0/CQF2tQu1NohlLVq8+n2EVsBuQv738IG
 i6X2qCzqI0eGL4qRhjK8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013, Chen Gang wrote:
>   when compiling with allmodconfig, CONFIG_64BIT=y
>     the file drivers/base/regmap/regmap-mmio.c will use readq and writeq.
> 
>   so we need implement these functions.
> 
> BTW:
>   the coding style can not pass ./scripts/checkpatch.pl.
>   it seems better to provide additional patch for beautifying code.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
