Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbbA2BRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:17:24 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41863 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbbA2BRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:17:17 -0500
MIME-Version: 1.0
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D88260F74AD@P3PWEX4MB008.ex4.secureserver.net>
References: <1422481761-31281-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<DC148C5AA1CEBA4E87973D432B1C2D88260F74AD@P3PWEX4MB008.ex4.secureserver.net>
Date: Wed, 28 Jan 2015 23:33:17 +0100
Message-ID: <CAKXHbyNvB+mKL8Fw1YKkV-hfkUGW93YKDsd_qrxBP-5BYjUc-w@mail.gmail.com>
Subject: Re: [PATCH v2] staging: comedi: drivers: addi-data: hwdrv_apci1500:
 Removed variables that is never used
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@gmail.com>,
        Conrad Meyer <cemeyer@uw.edu>, Fred Akers <knivey@botops.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-28 22:48 GMT+01:00 Hartley Sweeten <HartleyS@visionengravers.com>:
> On Wednesday, January 28, 2015 2:49 PM, Rickard Strandqvist wrote:
>> Variable ar assigned a value that is never used.
>> I have also removed all the code that thereby serves no purpose.
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c |   12 ++----------
>>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> This file has been deleted.
>
> Please base comedi patches on the current linux-next tree.
>
> Thanks,
> Hartley
>


Hi

Sorry, but I have now added a test that do a git apply on linux-next
before I send a patch.


Kind regards
Rickard Strandqvist
