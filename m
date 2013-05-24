Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3EXXu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:50:57 -0400
Received: from karen.lavabit.com ([72.249.41.33]:60877 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab3EXXu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:50:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=lavabit; d=lavabit.com;
  b=fr8UxsCxsqsk+Y98dkAallFI1/cUgq3yxQ/FxBthzbGAirHxzuHROlxq0Obx3oLSSEth/izblYVCkaeU0/BVJp1KQPDH2iCmmqT3JcwmqE5ZFRPRjEawi1fSsW3XTnmoWBz9Fl8Pc/jLfMbpYSUwt1wjG3let1WIhBp8k2srfQc=;
  h=Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
Message-ID: <519FFCDD.8070001@lavabit.com>
Date: Sat, 25 May 2013 02:50:53 +0300
From: Milen Kidane <MilenKidane@lavabit.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ata1.00: failed to enable AA (error_mask=0x1)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please advise if you can help me with bellow problem. I receive the
following messages on boot:

May 25 01:52:37 Leny kernel: ata1.00: failed to enable AA (error_mask=0x1)
May 25 01:52:37 Leny kernel: ata1.00: ATA-8: ST500LM012 HN-M500MBB,
2AR10001, max UDMA/100
May 25 01:52:37 Leny kernel: ata1.00: 976773168 sectors, multi 0: LBA48
NCQ (depth 31/32)
May 25 01:52:37 Leny kernel: ata1.00: failed to enable AA (error_mask=0x1)
May 25 01:52:37 Leny kernel: ata1.00: configured for UDMA/100
May 25 01:52:37 Leny kernel: scsi 0:0:0:0: Direct-Access     ATA     
ST500LM012 HN-M5 2AR1 PQ: 0 ANSI: 5

lspci shows the following:

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset
Family 6 port SATA AHCI Controller (rev 05)
        Subsystem: Lenovo Device 3975
        Kernel driver in use: ahci
        Kernel modules: ahci

I have read topics varying from "it's nothing" to "your HDD will fail
soon", so I really do not know what is this.

Please cc me in the reply if you can. Thank you very much.

