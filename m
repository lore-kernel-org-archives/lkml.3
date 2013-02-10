Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971Ab3BJPMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 10:12:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50606 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294Ab3BJPMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 10:12:07 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130210083616.GA4878@pd.tnic>
References: <20130209231351.GB5556@pd.tnic> <1360451762-10175-1-git-send-email-bp@alien8.de> <5117236D.5000607@zytor.com> <20130210083616.GA4878@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/5 -v2.1] x86: Detect CPUID support early at boot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 10 Feb 2013 07:10:56 -0800
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Message-ID: <168505a3-2aba-4d4a-b1e7-d37c79ae306c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure it does... it takes time.

Borislav Petkov <bp@alien8.de> wrote:

>On Sat, Feb 09, 2013 at 08:34:53PM -0800, H. Peter Anvin wrote:
>> I wouldn't really call it a "side effect". Perhaps the right thing
>> here is to say something like "we want to start out with %eflags
>> unambiguously clear".
>>
>> (Note also we have had to CLD earlier because we have already copied
>> the command line.)
>
>Ok, let's make it even more verbose so that people know in the future:
>
>"... we want to start out with EFLAGS unambiguously clear. That means
>DF
>in particular (even though we have cleared it earlier after copying the
>command line) because GCC expects it."
>
>How does that sound?
>
>Also, I was wondering about the whole reasoning behind that: do you
>know
>why DF=0 is a GCC requirement? I mean, nothing hurts GCC from issuing a
>CLD each time?
>
>Thanks.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
