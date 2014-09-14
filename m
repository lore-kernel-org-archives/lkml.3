Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaINWjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:39:43 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:25932 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaINWjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:39:42 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: scsi_devinfo.c: Cleaning up unnecessarily
 complicated in conjunction with strncpy
Thread-Topic: [PATCH] scsi: scsi_devinfo.c: Cleaning up unnecessarily
 complicated in conjunction with strncpy
Thread-Index: AQHP0GkrGrhtkjH3rEi/yW328+UERZwBNxfA
Date: Sun, 14 Sep 2014 22:38:02 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C7A8A6@G9W0745.americas.hpqcorp.net>
References: <1410727738-17430-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <94D0CD8314A33A4D9D801C0FE68B402958C7A75B@G9W0745.americas.hpqcorp.net>
 <CAFo99gbtGfEgcWukEQoEmcTro__aGND6-4bb4Ms+cV8Wu1FM4w@mail.gmail.com>
In-Reply-To: <CAFo99gbtGfEgcWukEQoEmcTro__aGND6-4bb4Ms+cV8Wu1FM4w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8EMdmuH011941



> -----Original Message-----
> From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
> How do you mean?
> 
> strncpy zeroes throughout the remainder of the string "from" until the
> length off to_length, or otherwise guaranteed trailing zero characters
> and a warning is printed.
> 
> Is not it exactly the functionality that is desired?

Ah, I see that in man 3 strcpy: 
    "If the length of src is less than n, strncpy() pads the 
     remainder of dest with null bytes."

I agree that should work.

---
Rob Elliott    HP Server Storage



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
