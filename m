Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaFHRSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 13:18:00 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55553 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaFHRR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 13:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <5393BF61.5010306@tilera.com>
References: <1401577213-3673-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<5393BF61.5010306@tilera.com>
Date: Sun, 8 Jun 2014 19:17:58 +0200
Message-ID: <CAFo99gbK8dsbMVDmef8MuJ3Ed6Lz0FPrMCm86ycMPTV+8gBO0w@mail.gmail.com>
Subject: Re: [PATCH] arch: tile: kernel: unaligned.c: Cleaning up
 uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris

So uint max was a better default value.
Yeah, good it came into use. The main thing that the code got a proper review :)


Kind regards
Rickard Strandqvist


2014-06-08 3:41 GMT+02:00 Chris Metcalf <cmetcalf@tilera.com>:
> On 5/31/2014 7:00 PM, Rickard Strandqvist wrote:
>>
>> There is a risk that the variable will be used without being initialized.
>>
>> This was largely found by using a static code analysis program called
>> cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist<rickard_strandqvist@spectrumdigital.se>
>> ---
>>   arch/tile/kernel/unaligned.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> Thanks!  Taken into the tile tree with some slight modifications (initialize
> variables to -1 not 0, and remove the resulting dead code in find_regs).
>
> --
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
>
