Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3LBW7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:59:39 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48927 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3LBW7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:59:35 -0500
Date: Mon, 2 Dec 2013 14:59:33 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 000/173] 3.10.22-stable review
Message-ID: <20131202225933.GA31983@roeck-us.net>
References: <20131202191142.873808297@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 11:09:43AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.22 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Dec  4 19:10:16 UTC 2013.
> Anything received after that time might be too late.
> 
Build results:
	total: 110 pass: 109 skipped: 0 fail: 1

qemu tests all passed.

The build failure is new.
avr32:atngw100mkii_evklcd101_defconfig fails to build with

lib/lib.a(vsprintf.o): In function `pointer':
vsprintf.c:(.text+0x17dc): relocation truncated to fit: R_AVR32_16N_PCREL against symbol `_ctype' defined in .text section in lib/lib.a(ctype.o)
make: *** [vmlinux] Error 1

Guenter
