Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbbAQPvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:51:13 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49035 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbAQPvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:51:12 -0500
MIME-Version: 1.0
In-Reply-To: <20150113033445.GA31207@kroah.com>
References: <1417989764-18481-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20150113033445.GA31207@kroah.com>
Date: Sat, 17 Jan 2015 16:51:10 +0100
Message-ID: <CAKXHbyPHNcaju7SG4A3xw2jUpN7qVQKPDWx4NKvKLCM4yfOM+Q@mail.gmail.com>
Subject: Re: [PATCH] staging: vt6655: mac.c: Remove unused function
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Forest Bond <forest@alittletooquiet.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Guillaume Clement <gclement@baobob.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-13 4:34 GMT+01:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Sun, Dec 07, 2014 at 11:02:44PM +0100, Rickard Strandqvist wrote:
>> Remove the function MACbCompareContext() that is not used anywhere.
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/vt6655/mac.c |   42 ------------------------------------------
>>  drivers/staging/vt6655/mac.h |    1 -
>>  2 files changed, 43 deletions(-)
>
> This doesn't apply to any tree that I can determine :(

Hi


Sorry, I have now investigated this and these function is now removed.

Kind regards
Rickard Strandqvist
