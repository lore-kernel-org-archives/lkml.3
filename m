Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab3EGXTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:19:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33159 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab3EGXTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:19:06 -0400
Message-ID: <51898BDD.90705@zytor.com>
Date: Tue, 07 May 2013 16:18:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The type of bitops
References: <51884263.4020608@zytor.com> <CA+55aFzwjQ03ZA71rgKMhCqh_+1fcMbPJUK3upcOacX2F8+Z9A@mail.gmail.com> <51898B87.9020005@mit.edu>
In-Reply-To: <51898B87.9020005@mit.edu>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 04:17 PM, Andy Lutomirski wrote:
> 
> The one and only time I tried to use this, I thought this was odd.  Long
> has a different size on 32 vs 64 bit architectures, and bit ops seem
> like they'd want to be the same size everywhere so you can allocate the
> appropriate number of bits.  (Also, if you only want 32 bits, you have
> to do some evil cheating, and I don't trust casting int* to long* on
> big-endian architectures.)
> 
> Would offering a u32* option make sense?
> 

Honestly, the only thing that makes sense on bigendian architectures is
either byte-by-byte elements or counting bit numbers from the MSB, but
that is serious water under the bridge at this point...

	-hpa


