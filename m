Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaKMHtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 02:49:35 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:41185 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaKMHte convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Thu, 13 Nov 2014 02:49:34 -0500
Message-Id: <5464709C0200007800047118@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 13 Nov 2014 07:49:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Tony Jones" <tonyj@suse.de>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, RFC] x86: also CFI-annotate certain inline asm()s
References: <5458A9600200007800044AE5@mail.emea.novell.com>
 <20141110100117.GA15841@gmail.com>
 <CA+55aFw9MV1n8T7_k5oftfY-sOu8s1ywKYM-3k4+PF022vv9ow@mail.gmail.com>
 <5461CC0702000078000464B3@mail.emea.novell.com>
 <CA+55aFzukHUryw_Jo4xvmb8RSADN9KrJ-HNk2U=8VCGwZzHaAw@mail.gmail.com>
In-Reply-To: <CA+55aFzukHUryw_Jo4xvmb8RSADN9KrJ-HNk2U=8VCGwZzHaAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.11.14 at 21:36, <torvalds@linux-foundation.org> wrote:
> On Mon, Nov 10, 2014 at 11:42 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>
>> Nothing crashes with the unwind information being wrong. It is
>> solely you who was claiming (without proof) years ago that the
>> unwinder repeatedly caused issues.
> 
> Umm. We had oopses showing it. Several times.

And I know you've been saying so before. The only problem here is
- these weren't sent my way for investigation, at least as far as I
recall.

>> Yes, we did find a bug or two over the years in it
> 
> .. and you and Andi repeatedly refused to make the code more robust
> when I asked.

True, we considered _some_ of the requests you made wrong.

> Which is why I don't work with Andi or you directly any more,

People thinking differently than you in certain aspects shouldn't
preclude working with them directly, should it? Yes, it's a project you
started, but it has long become a community one, and as such
excluding people just because they don't conform to every opinion
of yours is, well, odd.

> But this patch I NAK'ed because the code is not readable, and the
> infrastructure is not bearable.
> 
> Live with it.

I got the message.

Jan

