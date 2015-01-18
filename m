Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbbARQlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 11:41:51 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:61339 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbARQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 11:41:48 -0500
MIME-Version: 1.0
In-Reply-To: <20150117215839.GA18538@kroah.com>
References: <1419166779-2619-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20150117215839.GA18538@kroah.com>
Date: Sun, 18 Jan 2015 17:41:46 +0100
Message-ID: <CAKXHbyMjJUUYcSqvoE4eC_BdCEH1Lh3vLqCTaOf3GDvsKaQcjQ@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8723au: hal: rtl8723au_led.c: Remove some
 unused functions
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-17 22:58 GMT+01:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Sun, Dec 21, 2014 at 01:59:39PM +0100, Rickard Strandqvist wrote:
>> Removes some functions that are not used anywhere:
>> rtl8723au_DeInitSwLeds() rtl8723au_InitSwLeds()
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/rtl8723au/hal/rtl8723au_led.c    |   23 ----------------------
>>  drivers/staging/rtl8723au/include/rtl8723a_led.h |    2 --
>>  2 files changed, 25 deletions(-)
>
> These files aren't even in the tree anymore :(


Hi

No right. I can not find the files.
And can not find these functions anywhere anymore.

Sorry about that :(

Kind regards
Rickard Strandqvist
