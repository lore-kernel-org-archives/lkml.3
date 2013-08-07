Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab3HGTtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:49:15 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:61861 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3HGTtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:49:14 -0400
MIME-Version: 1.0
In-Reply-To: <2e3a4a90-2915-4b75-b807-b0e802e4955f@email.android.com>
References: <20130807173606.872055511@goodmis.org>
	<1375898048.6848.18.camel@gandalf.local.home>
	<CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
	<2e3a4a90-2915-4b75-b807-b0e802e4955f@email.android.com>
Date: Wed, 7 Aug 2013 12:49:13 -0700
X-Google-Sender-Auth: GSYo0qki4QkMGtoR1CM9XxGX8uA
Message-ID: <CA+55aFwNWsd4eSA_wZzz9L1q=ROkdBf_SBE5gYGSZksg-Kv2Jg@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short
 jumps used
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 12:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Well we do... both to extract relocations and to sort the exception table.  Perhaps we need to merge those kinds of postprocessing tools?

If we can do this generically and without adding 500 lines of
specialized code, my argument obviously goes away.

Exactly where the "unnecessarily complex" line is is obviously a
matter of taste.

                  Linus
