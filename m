Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaGHC4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:56:22 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:33957 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaGHC4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:56:20 -0400
MIME-Version: 1.0
Date: Mon, 7 Jul 2014 22:56:19 -0400
Message-ID: <CAPDOMVid3nbw0-3n_5d8QF_c5uOosWyYRPtqW29ZUB9Ziz7F+Q@mail.gmail.com>
Subject: Compile issues with se7206_defconfig
From: Nick Krause <xerofoify@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to me a build issue with this config. I will paste my logs
for this build below this message.
Cheers Nick
scripts/mod/empty.c:1:0: error: cannot use atomic model soft-imask in user mode
 /* empty file to figure out endianness / word size */
 ^
make[2]: *** [scripts/mod/empty.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/mod] Error 2
make[1]: *** Waiting for unfinished jobs....
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  Generating include/generated/machtypes.h
  CC      kernel/bounds.s
kernel/bounds.c:1:0: error: cannot use atomic model soft-imask in user mode
 /*
 ^
make[1]: *** [kernel/bounds.s] Error 1
make: *** [prepare0] Error 2
make: *** Waiting for unfinished jobs....
make: *** [scripts] Error 2
