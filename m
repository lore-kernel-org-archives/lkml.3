Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab3FROGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:06:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39799 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab3FROGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:06:03 -0400
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Subject: 3.10.0-RC6 compile failure in lpfc_vport
X-KeepSent: BE3EAFB0:E0D6FDC6-87257B8E:004B6880;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3FP4 SHF39 May 13, 2013
Message-ID: <OFBE3EAFB0.E0D6FDC6-ON87257B8E.004B6880-86257B8E.004BF5CF@us.ibm.com>
From: Christopher T Vogan <cvogan@us.ibm.com>
Date: Tue, 18 Jun 2013 08:49:43 -0500
X-MIMETrack: Serialize by Router on D03NM116/03/M/IBM(Release 8.5.3FP2 ZX853FP2HF5|February, 2013) at
 06/18/2013 07:49:43,
	Serialize complete at 06/18/2013 07:49:43
Content-Type: text/plain; charset="US-ASCII"
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061813-3620-0000-0000-0000032B08C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hit a compile issue when compiling the 3.10.0-RC6 kernel.  Did not see 
this problem on the RC5 kernel. Used the same .config.

  CC [M]  drivers/scsi/lpfc/lpfc_attr.o
  CC [M]  drivers/scsi/lpfc/lpfc_vport.o
{standard input}: Assembler messages:
{standard input}:67920: Error: symbol definition loop encountered at `#\'
gcc: Internal error: Segmentation fault (program as)
Please submit a full bug report.
See <http://bugzilla.redhat.com/bugzilla> for instructions.
make[3]: *** [drivers/scsi/lpfc/lpfc_vport.o] Error 1
make[2]: *** [drivers/scsi/lpfc] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2


Christopher Vogan
Dept. W98 NFS Development & Test

