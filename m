Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaEaJWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 05:22:45 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44093 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaEaJWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 05:22:43 -0400
X-Auth-Info: naRiWOkvsvO0Kwtqbqszq0/k9zdRPGVM6XIbKtw632s=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        hpa@zytor.com, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 03/32] fs: introduce sys_utimens64at
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-4-git-send-email-arnd@arndb.de>
X-Yow: I will invent "TIDY BOWL"...
Date: Sat, 31 May 2014 11:22:38 +0200
In-Reply-To: <1401480116-1973111-4-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Fri, 30 May 2014 22:01:27 +0200")
Message-ID: <m2ppiul2u9.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> +asmlinkage long sys_utimens64at(int dfd, const char __user *filename,

All existing syscall names have the 64 suffix last, including the *at
variants, so sys_utimensat64 would be more in line.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
