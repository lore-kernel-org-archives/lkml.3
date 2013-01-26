Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3AZPOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 10:14:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52764 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3AZPOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 10:14:40 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130126120853.GE13445@gmail.com>
References: <5093E40902000078000A6147@nat28.tlf.novell.com> <20130124171554.GC11772@gmail.com> <51017028.3020001@zytor.com> <51024E9602000078000B97A2@nat28.tlf.novell.com> <5102DD08.9080204@zytor.com> <20130126120853.GE13445@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3, v2] x86: xor-block handling adjustments
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2013 07:13:57 -0800
To: Ingo Molnar <mingo@kernel.org>
CC: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Message-ID: <c32f98cc-5996-4d8e-a5b7-1e2053840e88@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes.

Ingo Molnar <mingo@kernel.org> wrote:

>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> On 01/25/2013 12:21 AM, Jan Beulich wrote:
>> >>
>> >> I don't see anything wrong, except that I can't *find* patch 3/3
>either
>> >> in my inbox nor on LKML...
>> > 
>> > I can certainly resend the whole set, but our email system even
>> > got a delivery confirmation from yours on patch 3 (other than
>> > e.g. from Ingo's, and all of this identical to 0...2).
>> > 
>> > Or see https://patchwork.kernel.org/patch/1688991/, according
>> > to which you even responded to it (which is the concern Ingo was
>> > referring to).
>> > 
>> 
>> Ah yes, now I have the context.
>> 
>> And with that, I have to NAK the patch.  I did talk to the KVM 
>> people and they confirmed that this is NOT something they 
>> want.  They do not program VT-x to VMEXIT on CR0 changes.
>> 
>> So this is Xen-specific, and penalizing other hypervisors is 
>> wrong.
>
>Are patches #1 and #2 still OK?
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
