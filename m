Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaIVTqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:46:31 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59998 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbaIVTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:46:29 -0400
MIME-Version: 1.0
Date: Mon, 22 Sep 2014 12:46:28 -0700
Message-ID: <CA+r1ZhgZXEt=q8YrM__-jL-cyu-qY+k6R=hUP_f+6b_HPJ1wFA@mail.gmail.com>
Subject: make ARCH=i386 allyesconfig build error with next-20140922, in drivers/scsi/mpt2sas/mpt2sas_scsih.c
From: Jim Davis <jim.epost@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        nagalakshmi.nandigama@avagotech.com,
        praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com,
        abhijit.mahajan@avagotech.com, MPT-FusionLinux.pdl@avagotech.com,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/built-in.o: In function `_scsih_qcmd':
mpt2sas_scsih.c:(.text+0xf43d7b): undefined reference to `__udivdi3'
mpt2sas_scsih.c:(.text+0xf43db4): undefined reference to `__umoddi3'
make: *** [vmlinux] Error 1
