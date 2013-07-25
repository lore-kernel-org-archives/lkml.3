Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3GYCJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 22:09:15 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:43917 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3GYCJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 22:09:13 -0400
Date: Wed, 24 Jul 2013 22:09:13 -0400 (EDT)
From: Zhouping Liu <zliu@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1999182864.5191140.1374718153443.JavaMail.root@redhat.com>
In-Reply-To: <209887675.5191065.1374718087774.JavaMail.root@redhat.com>
Subject: [s390x] build error: undefined reference to `sie_exit'
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF22 (Linux)/8.0.3_GA_5664)
Thread-Topic: build error: undefined reference to `sie_exit'
Thread-Index: mPuuPsVtqj6rG/3L0RNcJP94BAsgsg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I met the below error on b3a3a9c441 with s390x arch:

# make
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHK     include/generated/uapi/linux/version.h
  LINK    vmlinux
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
arch/s390/built-in.o: In function `sys_call_table_emu':
(.rodata+0x2b98): undefined reference to `sie_exit'
arch/s390/built-in.o: In function `sys_call_table_emu':
(.rodata+0x2ba0): undefined reference to `sie_exit'
make: *** [vmlinux] Error 1


-- 
Thanks,
Zhouping
