Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3AWOo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:44:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45349 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab3AWOoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:44:54 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.LNX.2.00.1301231212420.20374@pobox.suse.cz>
References: <alpine.LNX.2.00.1301171118260.14768@pobox.suse.cz> <alpine.LNX.2.00.1301231212420.20374@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] time: x86: report_lost_ticks doesn't exist any more
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 23 Jan 2013 08:43:45 -0600
To: Jiri Kosina <jkosina@suse.cz>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Message-ID: <4b47e67f-b4b2-48ed-82cb-4ddaca5e1e77@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That works.  You can add my Ack if you want.  Thanks!

Jiri Kosina <jkosina@suse.cz> wrote:

>On Thu, 17 Jan 2013, Jiri Kosina wrote:
>
>> 'report_lost_ticks' parameter has been removed back in 2007 through 
>> 1489939f0ab ("time: x86_64: convert x86_64 to use GENERIC_TIME").
>> 
>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>> ---
>>  Documentation/x86/x86_64/boot-options.txt |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>> 
>> diff --git a/Documentation/x86/x86_64/boot-options.txt
>b/Documentation/x86/x86_64/boot-options.txt
>> index de38429..e015a83 100644
>> --- a/Documentation/x86/x86_64/boot-options.txt
>> +++ b/Documentation/x86/x86_64/boot-options.txt
>> @@ -112,10 +112,6 @@ Timing
>>    This can be used to work around timing problems on multiprocessor
>systems
>>    with not properly synchronized CPUs.
>>  
>> -  report_lost_ticks
>> -  Report when timer interrupts are lost because some code turned off
>> -  interrupts for too long.
>> -
>>    nohpet
>>    Don't use the HPET timer.
>
>Noone seems to have picked this up, I am taking it through trivial.git

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
