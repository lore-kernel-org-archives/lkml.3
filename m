Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaGDCu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 22:50:58 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56568 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaGDCu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 22:50:57 -0400
MIME-Version: 1.0
In-Reply-To: <53B524BC.6040301@mev.co.uk>
References: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com>
	<1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
	<53B524BC.6040301@mev.co.uk>
Date: Thu, 3 Jul 2014 21:50:56 -0500
Message-ID: <CA+jnaaX+n4v=G-Zqxd41c-uDVAN9yP=yqA0HK7c+Ey8o2n6ACw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] staging: comedi: addi_apci_1564: miscellaneous
 fixes and cleanups
From: Chase Southwood <chase.southwood@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        hsweeten@visionengravers.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 4:39 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
> On 2014-07-03 03:15, Chase Southwood wrote:
>>
>> This patchset moves a misplaced include to the proper file, swaps out an
>> overly
>> aggressive placement of apci1564_reset(), and cleans up
>> apci1564_interrupt().
>>
>> Chase Southwood (3):
>>    staging: comedi: addi_apci_1564: move addi_watchdog.h include to
>>      addi_apci_1564.c
>>    staging: comedi: addi_apci_1564: fix use of apci1564_reset() to
>>      disable DI interrupts
>>    staging: comedi: addi_apci_1564: clean up apci1564_interrupt()
>>
>>   .../comedi/drivers/addi-data/hwdrv_apci1564.c      |   2 -
>>   drivers/staging/comedi/drivers/addi_apci_1564.c    | 139
>> +++++----------------
>>   2 files changed, 32 insertions(+), 109 deletions(-)
>>
>
> Looks good!  You didn't list the v2 changes though.  Maybe you could
> summarize them here?

I always forget to do _something_, don't I?  Here are the changes:

CHANGES FROM V1:
*Patches 1 and 2 did not change.
*In Patch 3, check for interrupts from unknown sources has been removed.
*Individual status variables for the subdevices in the interrupt
handler have been swapped out in favor of a single status variable
that is reused for all subdevices.

Thanks,
Chase
>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk.>
>
>
> --
> -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
> -=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
