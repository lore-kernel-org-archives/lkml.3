Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab3APKKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:10:13 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:41911 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab3APKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:10:07 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <43EB3AB3EEFE8D43B525F4D2EAF507E107F4160E@SCYBEXDAG04.amd.com>
References: <CA+icZUUCB3K1=DuM6Nonu+Qc+qg3cM_ODk9TDZ-uYCfLVOhrdw@mail.gmail.com>
	<CA+icZUXrQ4aq+cKXj3qEwnhtTGPBfHcJ6q_zTm3xSBUUh9W8dQ@mail.gmail.com>
	<CA+icZUVBdsAa7ZA7e_UNpBsAOpVOXcawhUncbHNdkC-MGY4qLw@mail.gmail.com>
	<43EB3AB3EEFE8D43B525F4D2EAF507E107F4160E@SCYBEXDAG04.amd.com>
Date: Wed, 16 Jan 2013 11:10:06 +0100
Message-ID: <CA+icZUU7UmoYb5j7Pg57pMdgfw5GNA=M0aBuc5362o2t7Hqt3w@mail.gmail.com>
Subject: Re: [3.8-{rc1,rc2}] ata1.00: failed to get Identify Device Data,
 Emask 0x1
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Huang, Shane" <Shane.Huang@amd.com>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        linux-next <linux-next@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 5, 2013 at 3:20 AM, Huang, Shane <Shane.Huang@amd.com> wrote:
>> OK, I see the patch I mentioned to fix the problem was later reverted [1].
>> The real fix is "libata: replace sata_settings with devslp_timing" [2].
>
> Yes, please use [2] which can also be found in kernel bugzilla #51881
> and is pending on Jeff's acceptance. Sorry for the trouble to you guys.
>

[ CCing Linus ]

Thanks for taking care (my latest experiences on LKML/linux-next tell
me even this is no more the fact!)!

Your patch finally hit Linux-Next (next-20130116) and IIRC it is also
marked for previous Linux-kernel releases (CC -stable).
I have tested your patch as said also against Linux v3.8-rcX.

Unfortunately, the applied patch in Linux-Next does not contain any of
my desired Reported-by/Tested-by.
This makes me a bit unhappy, but I do NOT insist on it.

Mr. Torvalds himself pointed several times to all maintainers to
honour people - even they report and ideally report-and-test!

I am doing all my testings in my free-time and I am not paid for it.
I am raping my hardware here!
I can't do more than that!

- Sedat -

> Thanks,
> Shane
