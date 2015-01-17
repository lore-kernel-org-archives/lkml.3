Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbbAQPeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:34:11 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47466 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbbAQPeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:34:09 -0500
MIME-Version: 1.0
In-Reply-To: <20150113034227.GA16203@kroah.com>
References: <1419184983-11386-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20150113034227.GA16203@kroah.com>
Date: Sat, 17 Jan 2015 16:34:07 +0100
Message-ID: <CAKXHbyPLov0STreiWy3GOoAMM7xNAVdCZSXZTwhgn5eD1SPg-g@mail.gmail.com>
Subject: Re: [PATCH] staging: vt6655: srom.c: Remove some unused functions
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Guillaume Clement <gclement@baobob.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-13 4:42 GMT+01:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Sun, Dec 21, 2014 at 07:03:03PM +0100, Rickard Strandqvist wrote:
>> Removes some functions that are not used anywhere:
>> SROMbAutoLoad() SROMvReadSubSysVenId() SROMvWriteEtherAddress()
>> SROMvWriteAllContents() SROMbIsRegBitsOff() SROMbIsRegBitsOn()
>> SROMvRegBitsOff() SROMvRegBitsOn()
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/vt6655/srom.c |  206 -----------------------------------------
>>  drivers/staging/vt6655/srom.h |   11 ---
>>  2 files changed, 217 deletions(-)
>
> This doesn't apply at all to my tree :(


Hi

Have now investigated this and these functions are now removed.

However, all function names still in a comment part in the vt6655/srom.c file.


Kind regards
Rickard Strandqvist
