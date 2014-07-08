Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaGHDR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:17:26 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:49734 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaGHDRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:17:25 -0400
MIME-Version: 1.0
Date: Mon, 7 Jul 2014 23:17:24 -0400
Message-ID: <CAPDOMVjMVCXP+ESan9Sk7iPQAoBTRvw5F8+D_O26m+nPEL9Cog@mail.gmail.com>
Subject: sh allmodconfig Fails
From: Nick Krause <xerofoify@gmail.com>
To: kirill.shutemov@linux.intel.com
Cc: peterz@infradead.org, mgorman@suse.de, riel@redhat.com, mingo@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Kirill and other maintainers ,
When building sh allmodconfig I hit errors in a file you guys maintain.
I will paste below this log the issues with the build and their respective
errors.
Cheers Nick :)
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
./scripts/gcc-version.sh: line 31: printf: #: invalid number
./scripts/gcc-version.sh: line 31: printf: #: invalid number
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
./scripts/gcc-version.sh: line 31: printf: #: invalid number
./scripts/gcc-version.sh: line 31: printf: #: invalid number
/bin/sh: 1: [: 0001: unexpected operator
  CHK     include/generated/utsrelease.h
  HOSTCC  scripts/genksyms/genksyms.o
  CC      scripts/mod/empty.o
scripts/mod/empty.c:1:0: error: cannot use atomic model soft-imask in user mode
 /* empty file to figure out endianness / word size */
 ^
make[2]: *** [scripts/mod/empty.o] Error 1
make[1]: *** [scripts/mod] Error 2
make[1]: *** Waiting for unfinished jobs....
  HOSTCC  scripts/genksyms/lex.lex.o
  HOSTCC  scripts/genksyms/parse.tab.o
make[1]: `include/generated/machtypes.h' is up to date.
  HOSTLD  scripts/genksyms/genksyms
  CC      kernel/bounds.s
kernel/bounds.c:1:0: error: cannot use atomic model soft-imask in user mode
 /*
 ^
make[1]: *** [kernel/bounds.s] Error 1
make: *** [prepare0] Error 2
make: *** Waiting for unfinished jobs....
make: *** [scripts] Error 2
