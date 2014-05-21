Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaEUGDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:03:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaEUGDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:03:10 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140521060100.GA5484@gmail.com>
References: <20140521141249.6f87b7e7@canb.auug.org.au> <537C2A72.9030503@zytor.com> <20140521060100.GA5484@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 20 May 2014 23:02:01 -0700
To: Ingo Molnar <mingo@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Message-ID: <31a51237-ff54-4beb-b905-60ed8f13b5fb@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok.  Will do.

On May 20, 2014 11:01:00 PM PDT, Ingo Molnar <mingo@kernel.org> wrote:
>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> On 05/20/2014 09:12 PM, Stephen Rothwell wrote:
>> > Hi all,
>> > 
>> > Today's linux-next merge of the tip tree got a conflict in 
>> > arch/x86/kernel/ldt.c between commit fa81511bb0bb ("x86-64,
>> > modify_ldt: Make support for 16-bit segments a runtime option")
>> > from Linus' tree and commit 34273f41d57e ("x86, espfix: Make it
>> > possible to disable 16-bit support") from the tip tree.
>> > 
>> > I fixed it up (see below) and can carry the fix as necessary (no
>> > action is required).
>> > 
>> 
>> This (and the previous one) is not the correct fix, although it will
>> work.  The correct fix is instead to completely revert fa81511bb0bb
>> before merging in tip:x86/espfix.
>> 
>> Sorry for the inconvenience.  Linus generally doesn't like it when we
>> fix up merges for him, or I'd set up a "clean" tip:x86/espfix branch.
>
>Please merge x86/urgent into x86/vdso while memories are still fresh - 
>fixing up conflicts between our own branches is entirely fine (I'm 
>doing it all the time to help the development flow) and it will make 
>life easier.
>
>What Linus dislikes most are merges between completely _unrelated_ 
>topic branches, especially if they cross maintenance domains.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
