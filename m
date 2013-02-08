Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3BHGDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:03:50 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:37114 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3BHGDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:03:32 -0500
From: "NickCheng" <nick.cheng@areca.com.tw>
To: <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <jejb@kernel.org>,
        "???" <ching2048@areca.com.tw>
Subject: [PATCH 3/5]  arcmsr: Support MSI and MSI-X
Date: Fri, 8 Feb 2013 14:02:46 +0800
Message-ID: <F09D285F14A941CA929D3AAC3992BA8C@arecaaebe11fae>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0006_01CE0604.FA361FD0"
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac2hXXYG8W24nt0/Q/6mWt8IlNnnHQ==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0006_01CE0604.FA361FD0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Support MSI or MSI-X for whole series of RAID controllers. Meanwhile correct the register access as iowrite32/ioread32 
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_0006_01CE0604.FA361FD0
Content-Type: application/octet-stream;
	name="checkpatch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="checkpatch3"

WARNING: printk() should include KERN_ facility level=0A=
#42: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:885:=0A=
+				printk("arcmsr%d: request_irq =3D %d failed!\n",=0A=
=0A=
WARNING: braces {} are not necessary for any arm of this statement=0A=
#71: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:926:=0A=
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
[...]=0A=
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
[...]=0A=
=0A=
ERROR: Missing Signed-off-by: line(s)=0A=
=0A=
total: 1 errors, 2 warnings, 114 lines checked=0A=
=0A=
../patch3 has style problems, please review.=0A=
=0A=
If any of these errors are false positives, please report=0A=
them to the maintainer, see CHECKPATCH in MAINTAINERS.=0A=

------=_NextPart_000_0006_01CE0604.FA361FD0--

