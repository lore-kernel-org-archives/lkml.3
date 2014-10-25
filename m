Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaJYCil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 22:38:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50874 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaJYCik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 22:38:40 -0400
Message-ID: <544B0D22.2070509@zytor.com>
Date: Fri, 24 Oct 2014 19:38:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: vmalloced stacks on x86_64?
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
In-Reply-To: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 05:22 PM, Andy Lutomirski wrote:
> Is there any good reason not to use vmalloc for x86_64 stacks?

Additional TLB pressure if anything else.

Now, on the flipside: what is the *benefit*?

	-hpa

