Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3K0Cqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:46:34 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33541 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3K0Cqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:46:31 -0500
Date: Wed, 27 Nov 2013 10:46:23 +0800
From: kedacomkernel <kedacomkernel@gmail.com>
To: nab <nab@linux-iscsi.org>,
        "Jayamohan Kallickal" <Jayamohan.Kallickal@Emulex.Com>
Cc: open-iscsi <open-iscsi@googlegroups.com>,
        "Mike Christie" <michaelc@cs.wisc.edu>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        "Or Gerlitz" <ogerlitz@mellanox.com>
Reply-To: kedacomkernel <kedacomkernel@gmail.com>
Subject: Re: Re: scsi-mq + open-iscsi support patches..?
References: <1382997816.19256.767.camel@haakon3.risingtidesystems.com> <5273BEBF.2090008@cs.wisc.edu> <1383338230.4216.9.camel@haakon3.risingtidesystems.com> <37724B2049F71D4C9B086F99DDB2DE1126E31C7C@CMEXMB1.ad.emulex.com>, 
	<1383591411.4216.25.camel@haakon3.risingtidesystems.com>
X-Priority: 3
X-GUID: 792B5A08-8FC4-4E81-8E32-882821F373D7
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201311271046199969490@gmail.com>
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAR2l5Pt018340

Hi allï¼Œ
	I used target-pending/scsi-mq to test intel ahciï¼Œbut it can't work.I modify some places, now it can work.But still met hung task or oops.
Who can receive my patch for that?

Thanks!
Jianpeng Ma
>On Sat, 2013-11-02 at 16:10 +0000, Jayamohan Kallickal wrote:
>
><SNIP>
>
>> >> On a related note, some iscsi vendor has been hitting a crash with 
>> >> your tree.
>> 
>> >I got an email from Jayamohan recently, but the OOPs did not appear to be scsi-mq related..
>> 
>> I do see the crash on my Ubuntu VM running on VirtualBox  but don't see the crash on a Standalone system. 
>> Attaching the screenshot
>> 
>
>Hi Jayamohan,
>
>Care to enable the virtual serial port for this VM in order to grab the
>full dmesg output..?
>
>Also, an idea of what SATA emulation is being used here would be helpful
>as well.  (eg: lspci -vvv for the ATA device on the running system)
>
>--nab
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.htmlÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
