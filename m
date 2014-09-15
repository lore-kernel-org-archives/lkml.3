Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbaIOUre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:47:34 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33663 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758457AbaIOUrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:47:31 -0400
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C7A8A6@G9W0745.americas.hpqcorp.net>
References: <1410727738-17430-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <94D0CD8314A33A4D9D801C0FE68B402958C7A75B@G9W0745.americas.hpqcorp.net>
 <CAFo99gbtGfEgcWukEQoEmcTro__aGND6-4bb4Ms+cV8Wu1FM4w@mail.gmail.com> <94D0CD8314A33A4D9D801C0FE68B402958C7A8A6@G9W0745.americas.hpqcorp.net>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 15 Sep 2014 22:47:07 +0200
Message-ID: <CAFo99gYiSViTkek8uv_vBHyxG47An+giKuCS7SPR3FwGK1_SAw@mail.gmail.com>
Subject: Re: [PATCH] scsi: scsi_devinfo.c: Cleaning up unnecessarily
 complicated in conjunction with strncpy
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-15 0:38 GMT+02:00 Elliott, Robert (Server Storage) <Elliott@hp.com>:
>
>
>> -----Original Message-----
>> From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
>> How do you mean?
>>
>> strncpy zeroes throughout the remainder of the string "from" until the
>> length off to_length, or otherwise guaranteed trailing zero characters
>> and a warning is printed.
>>
>> Is not it exactly the functionality that is desired?
>
> Ah, I see that in man 3 strcpy:
>     "If the length of src is less than n, strncpy() pads the
>      remainder of dest with null bytes."
>
> I agree that should work.
>
> ---
> Rob Elliott    HP Server Storage


Hi

Okay, good.
Suspected that there was some misunderstanding :)

Kind regards
Rickard Strandqvist
