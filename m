Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3CRTRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:17:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38608 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab3CRTRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:17:12 -0400
Message-ID: <514767A5.4020601@zytor.com>
Date: Mon, 18 Mar 2013 12:14:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Lin Feng <linfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, penberg@kernel.org,
        jacob.shin@amd.com
Subject: Re: [PATCH] x86: mm: accurate the comments for STEP_SIZE_SHIFT macro
References: <1363602068-11924-1-git-send-email-linfeng@cn.fujitsu.com> <CAE9FiQWuSL5Vq5VaAvQg_NT2gQJr17eMNoQbxtNJ8G3wweWNHQ@mail.gmail.com> <51476402.7050102@zytor.com> <CAE9FiQUZDqqeAp2y=Pc9yFT81Pf+ei2SEx4NUD6jC+nQmd6PcA@mail.gmail.com>
In-Reply-To: <CAE9FiQUZDqqeAp2y=Pc9yFT81Pf+ei2SEx4NUD6jC+nQmd6PcA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 12:13 PM, Yinghai Lu wrote:
>>
>> No, it doesn't.  This is C, not elementary school  Now I'm really bothered.
>>
>> The comment doesn't say *why* (PUD_SHIFT-PMD_SHIFT)/2 or any other
>> variant is correct, furthermore I suspect that the +1 is misplaced.
>> However, what is really needed is:
>>
>> 1. Someone needs to explain what the logic should be and why, and
>> 2. replace the macro with a symbolic macro, not with a constant and a
>>    comment explaining, incorrectly, how that value was derived.
> 
> yes, we should find out free_mem_size instead to decide next step size.
> 
> But that will come out page table size estimation problem again.
> 

Sorry, that comment is double nonsense for someone who isn't intimately
familiar with the code, and it sounds like it is just plain wrong.

Instead, try to explain why 5 is the correct value in the current code
and how it is (or should be!) derived.

	-hpa



