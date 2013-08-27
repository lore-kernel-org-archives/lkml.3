Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3H0Xqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:46:53 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42558 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3H0Xqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:46:52 -0400
Date: Tue, 27 Aug 2013 16:46:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.11-rc6 many problems,  wil6210 , snd-pcsp , ibmphp
Message-ID: <20130827234649.GA24002@roeck-us.net>
References: <web-25718928@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <web-25718928@zbackend1.aha.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 02:50:30PM -0400, werner wrote:
> With compiling and using this, have too much problems
> 
[ ... ]

> 
>   CC      arch/x86/crypto/crc32c-intel.mod.o
>   LD [M]  arch/x86/crypto/crc32c-intel.ko
>   CC      arch/x86/crypto/salsa20-i586.mod.o
>   LD [M]  arch/x86/crypto/salsa20-i586.ko
>   CC      arch/x86/kvm/kvm-amd.mod.o
>   LD [M]  arch/x86/kvm/kvm-amd.ko
>   CC      arch/x86/kvm/kvm-intel.mod.o
>   LD [M]  arch/x86/kvm/kvm-intel.ko
>   CC      arch/x86/kvm/kvm.mod.o
>   LD [M]  arch/x86/kvm/kvm.ko
>   CC      crypto/ansi_cprng.mod.o
> gcc: crypto/ansi_cprng.mod.c: No such file or directory
> gcc: no input files
> make[1]: [crypto/ansi_cprng.mod.o] Error 1 (ignored)
>   LD [M]  crypto/ansi_cprng.ko
> ld: crypto/ansi_cprng.mod.o: No such file: No such file or directory
> make[1]: [crypto/ansi_cprng.ko] Error 1 (ignored)
>   CC      crypto/ccm.mod.o
> gcc: crypto/ccm.mod.c: No such file or directory
> gcc: no input files

(and so on)

This is a side effect of commit ea4054a2384 (handle huge number of modules).
See https://lkml.org/lkml/2013/5/8/493.

Guenter
