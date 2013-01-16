Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3APNvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:51:24 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43490 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab3APNvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:51:22 -0500
Message-ID: <50F6B018.2020800@pobox.com>
Date: Wed, 16 Jan 2013 08:50:16 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: "Huang, Shane" <Shane.Huang@amd.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        linux-next <linux-next@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.8-{rc1,rc2}] ata1.00: failed to get Identify Device Data,
 Emask 0x1
References: <CA+icZUUCB3K1=DuM6Nonu+Qc+qg3cM_ODk9TDZ-uYCfLVOhrdw@mail.gmail.com> <CA+icZUXrQ4aq+cKXj3qEwnhtTGPBfHcJ6q_zTm3xSBUUh9W8dQ@mail.gmail.com> <CA+icZUVBdsAa7ZA7e_UNpBsAOpVOXcawhUncbHNdkC-MGY4qLw@mail.gmail.com> <43EB3AB3EEFE8D43B525F4D2EAF507E107F4160E@SCYBEXDAG04.amd.com> <CA+icZUU7UmoYb5j7Pg57pMdgfw5GNA=M0aBuc5362o2t7Hqt3w@mail.gmail.com>
In-Reply-To: <CA+icZUU7UmoYb5j7Pg57pMdgfw5GNA=M0aBuc5362o2t7Hqt3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 05:10 AM, Sedat Dilek wrote:
> On Sat, Jan 5, 2013 at 3:20 AM, Huang, Shane <Shane.Huang@amd.com> wrote:
>>> OK, I see the patch I mentioned to fix the problem was later reverted [1].
>>> The real fix is "libata: replace sata_settings with devslp_timing" [2].
>>
>> Yes, please use [2] which can also be found in kernel bugzilla #51881
>> and is pending on Jeff's acceptance. Sorry for the trouble to you guys.
>>
>
> [ CCing Linus ]
>
> Thanks for taking care (my latest experiences on LKML/linux-next tell
> me even this is no more the fact!)!
>
> Your patch finally hit Linux-Next (next-20130116) and IIRC it is also
> marked for previous Linux-kernel releases (CC -stable).
> I have tested your patch as said also against Linux v3.8-rcX.
>
> Unfortunately, the applied patch in Linux-Next does not contain any of
> my desired Reported-by/Tested-by.
> This makes me a bit unhappy, but I do NOT insist on it.
>
> Mr. Torvalds himself pointed several times to all maintainers to
> honour people - even they report and ideally report-and-test!
>
> I am doing all my testings in my free-time and I am not paid for it.
> I am raping my hardware here!
> I can't do more than that!

We definitely appreciate that.  The patch in question actually went into 
the git repository before your report was received.  You did not see it 
in linux-next until my local git repository was pushed out to kernel.org 
(and thus automatically included in linux-next).

	Jeff




