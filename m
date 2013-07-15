Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3GOGMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:12:35 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:55013 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3GOGMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:12:34 -0400
Message-ID: <51E392CE.9000605@kernel.org>
Date: Mon, 15 Jul 2013 09:12:30 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SLAB changes for v3.11-rc0
References: <alpine.LFD.2.03.1307142205090.2124@kernel.org> <CA+55aFytd8NZeX1ux8U56uQk65N3jcq_7UMv1RrFgAPmLJc-dw@mail.gmail.com>
In-Reply-To: <CA+55aFytd8NZeX1ux8U56uQk65N3jcq_7UMv1RrFgAPmLJc-dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 10:58 PM, Linus Torvalds wrote:
> On Sun, Jul 14, 2013 at 12:06 PM, Pekka Enberg <penberg@kernel.org> wrote:
>>
>> The tree also contains Christoph's unification work that I merged in
>> too late had to revert because it broke things. We'll try again for
>> v3.12.
>
> Ugh. I'll merge the commits leading up to that, but not the actual
> broken try at unification at all.
>
> There's just one one-liner patch in between the broken commits and
> their reverts, I don't see the point of pulling that part at all, and
> I can take the one-liner separately.

OK, I'll requeue the oneliner commit. Thanks!

			Pekka

