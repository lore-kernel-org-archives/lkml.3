Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3EGBgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:36:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49235 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758214Ab3EGBgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:36:49 -0400
Message-ID: <51885AA0.4090807@zytor.com>
Date: Mon, 06 May 2013 18:36:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The type of bitops
References: <51884263.4020608@zytor.com> <CA+55aFzwjQ03ZA71rgKMhCqh_+1fcMbPJUK3upcOacX2F8+Z9A@mail.gmail.com>
In-Reply-To: <CA+55aFzwjQ03ZA71rgKMhCqh_+1fcMbPJUK3upcOacX2F8+Z9A@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 05:51 PM, Linus Torvalds wrote:
> 
>> 4. Do some macro hacks so the bitops are dependent on the size of the
>>    argument.
> 
> That sounds insane. Just *how* could the size of the argument even
> matter? Seriously, there's no *difference* between a 32-bit or a
> 64-bit index. The code is the same, there's no possible reason to make
> it be different.
> 

The only reason on x86 would be to avoid the REX prefix.  Hardly worth
it, though.

	-hpa

