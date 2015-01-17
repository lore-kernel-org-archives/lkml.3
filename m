Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbbAQPpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:45:34 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38870 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbbAQPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:45:33 -0500
MIME-Version: 1.0
In-Reply-To: <20150113034329.GA22444@kroah.com>
References: <1420132712-32285-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20150113034329.GA22444@kroah.com>
Date: Sat, 17 Jan 2015 16:45:31 +0100
Message-ID: <CAKXHbyNpj6zQtScQxuWYWTkAj5=240uP6L6ufm-wxNF03zdSLg@mail.gmail.com>
Subject: Re: [PATCH] staging: vt6655: mib.c: Remove some unused functions
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Forest Bond <forest@alittletooquiet.net>, Joe Perches <joe@perches.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-13 4:43 GMT+01:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Thu, Jan 01, 2015 at 06:18:32PM +0100, Rickard Strandqvist wrote:
>> Removes some functions that are not used anywhere:
>> STAvClearAllCounter() STAvClear802_11Counter()
>> STAvUpdateTDStatCounterEx() STAvUpdateRDStatCounterEx()
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/vt6655/mib.c |  113 ------------------------------------------
>>  drivers/staging/vt6655/mib.h |   14 ------
>>  2 files changed, 127 deletions(-)
>
> Doesn't apply, what are you making these patches against?
>

Hi

Have now investigated this and these functions are now removed.


Kind regards
Rickard Strandqvist
