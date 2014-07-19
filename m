Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaGSVdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 17:33:18 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34249 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaGSVdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 17:33:17 -0400
MIME-Version: 1.0
In-Reply-To: <1405771556.18077.5.camel@x220>
References: <1405746604-7737-1-git-send-email-xerofoify@gmail.com>
	<1405771556.18077.5.camel@x220>
Date: Sat, 19 Jul 2014 17:33:16 -0400
Message-ID: <CAPDOMVgQ-F9Y4AoNfFW-vN0YP10kwYL-GCwkpnXj+zg_UMJ4jw@mail.gmail.com>
Subject: Re: [PATCH] mips: Remove uneeded line in cmp_smp_finish
From: Nick Krause <xerofoify@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: ralf@linux-mips.org, paul.burton@imgtec.com, Leonid.Yegoshin@imgtec.com,
        markos.chandras@imgtec.com, Steven.Hill@imgtec.com,
        linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 8:05 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sat, 2014-07-19 at 01:10 -0400, Nicholas Krause wrote:
>> This patch removes a unneeded line from this file as stated by the
>> fix me in this file.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  arch/mips/kernel/smp-cmp.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
>> index fc8a515..61bfa20 100644
>> --- a/arch/mips/kernel/smp-cmp.c
>> +++ b/arch/mips/kernel/smp-cmp.c
>> @@ -60,8 +60,6 @@ static void cmp_smp_finish(void)
>>  {
>>       pr_debug("SMPCMP: CPU%d: %s\n", smp_processor_id(), __func__);
>>
>> -     /* CDFIXME: remove this? */
>> -     write_c0_compare(read_c0_count() + (8 * mips_hpt_frequency / HZ));
>
> That comment ends in a question mark. I wonder why...
>
>>  #ifdef CONFIG_MIPS_MT_FPAFF
>>       /* If we have an FPU, enroll ourselves in the FPU-full mask */
>
>
> Paul Bolle
>
If we need it then can I remove the FIx me comment.
Cheers Nick
