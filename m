Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaGURe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:34:57 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59098 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaGURe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:34:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140721081931.GC30558@pburton-laptop>
References: <1405746604-7737-1-git-send-email-xerofoify@gmail.com>
	<1405771556.18077.5.camel@x220>
	<CAPDOMVgQ-F9Y4AoNfFW-vN0YP10kwYL-GCwkpnXj+zg_UMJ4jw@mail.gmail.com>
	<20140721081931.GC30558@pburton-laptop>
Date: Mon, 21 Jul 2014 13:34:55 -0400
Message-ID: <CAPDOMVgnonw5+ZB6GjRUSVex6_EdXC-ZL-L_YUCSaZ=M5UHQiw@mail.gmail.com>
Subject: Re: [PATCH] mips: Remove uneeded line in cmp_smp_finish
From: Nick Krause <xerofoify@gmail.com>
To: Paul Burton <paul.burton@imgtec.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, ralf@linux-mips.org,
        Leonid.Yegoshin@imgtec.com, markos.chandras@imgtec.com,
        Steven.Hill@imgtec.com, linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 4:19 AM, Paul Burton <paul.burton@imgtec.com> wrote:
> On Sat, Jul 19, 2014 at 05:33:16PM -0400, Nick Krause wrote:
>> On Sat, Jul 19, 2014 at 8:05 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> > On Sat, 2014-07-19 at 01:10 -0400, Nicholas Krause wrote:
>> >> This patch removes a unneeded line from this file as stated by the
>> >> fix me in this file.
>> >>
>> >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> >> ---
>> >>  arch/mips/kernel/smp-cmp.c | 2 --
>> >>  1 file changed, 2 deletions(-)
>> >>
>> >> diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
>> >> index fc8a515..61bfa20 100644
>> >> --- a/arch/mips/kernel/smp-cmp.c
>> >> +++ b/arch/mips/kernel/smp-cmp.c
>> >> @@ -60,8 +60,6 @@ static void cmp_smp_finish(void)
>> >>  {
>> >>       pr_debug("SMPCMP: CPU%d: %s\n", smp_processor_id(), __func__);
>> >>
>> >> -     /* CDFIXME: remove this? */
>> >> -     write_c0_compare(read_c0_count() + (8 * mips_hpt_frequency / HZ));
>> >
>> > That comment ends in a question mark. I wonder why...
>> >
>> >>  #ifdef CONFIG_MIPS_MT_FPAFF
>> >>       /* If we have an FPU, enroll ourselves in the FPU-full mask */
>> >
>> >
>> > Paul Bolle
>> >
>> If we need it then can I remove the FIx me comment.
>> Cheers Nick
>
> That depends: have you verified that we do need it?
>
> I wouldn't feel comfortable with removing either line without someone
> first explaining why it isn't necessary and testing the result on a
> number of different systems, with varying combinations of csrc-r4k &
> cevt-r4k.
>
> I absolutely agree that removing unnecessary code or outdated comments
> are both good things, but let's be sure they're unnecessary or outdated
> first. Your patch does not make me confident that you've checked either
> of those.
>
> Thanks,
>     Paul


I don't have this hardware , however if we can find people to test
this it would be great.
Cheers Nick
