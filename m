Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaGHD3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:29:19 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:54264 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaGHD3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:29:18 -0400
MIME-Version: 1.0
Date: Mon, 7 Jul 2014 23:29:17 -0400
Message-ID: <CAPDOMVgTrH3eu2kuNpTFbL=uidiFQGdJYxD-p_mxBjoYoPTdKQ@mail.gmail.com>
Subject: sh -allyesconfig Fails
From: Nick Krause <xerofoify@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,
sh    allyesconfig seems to still be failing. Below this message are
the logs for this failing build.
Cheers Nick
scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
./scripts/gcc-version.sh: line 31: printf: #: invalid number
./scripts/gcc-version.sh: line 31: printf: #: invalid number
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
./scripts/gcc-version.sh: line 31: printf: #: invalid number
./scripts/gcc-version.sh: line 31: printf: #: invalid number
/bin/sh: 1: [: 0001: unexpected operator
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
<stdin>:1:0: error: cannot use atomic model soft-imask in user mode
./scripts/gcc-version.sh: line 31: printf: #: invalid number
./scripts/gcc-version.sh: line 31: printf: #: invalid number
/bin/sh: 1: [: 0001: unexpected operator
  CHK     include/generated/utsrelease.h
  CC      scripts/mod/empty.o
scripts/mod/empty.c:1:0: error: cannot use atomic model soft-imask in user mode
 /* empty file to figure out endianness / word size */
 ^
make[2]: *** [scripts/mod/empty.o] Error 1
make[1]: *** [scripts/mod] Error 2
make: *** [scripts] Error 2
make: *** Waiting for unfinished jobs....
