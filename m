Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab3BZUCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 15:02:09 -0500
Received: from mail.servus.at ([193.170.194.20]:36557 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759622Ab3BZUCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 15:02:07 -0500
Message-ID: <512D14BA.5080401@oberhumer.com>
Date: Tue, 26 Feb 2013 21:02:02 +0100
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] Update LZO compression code for v3.9
References: <51270182.4080205@oberhumer.com> <CA+55aFy0jezoatAQKOYDPHifG9Lhyp2ZC=fYTFU2tpzxOhTa3Q@mail.gmail.com>
In-Reply-To: <CA+55aFy0jezoatAQKOYDPHifG9Lhyp2ZC=fYTFU2tpzxOhTa3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-26 18:28, Linus Torvalds wrote:
> On Thu, Feb 21, 2013 at 9:26 PM, Markus F.X.J. Oberhumer
> <markus@oberhumer.com> wrote:
>>
>> please pull my "lzo-update" branch from
>>
>>   git://github.com/markus-oberhumer/linux.git lzo-update
> 
> I *really* want github (and other general hosting) pull requests to be
> for signed tags, so that I can see your gpg key and there is some real
> trail of who things got pulled from.
> 
> I prefer he signed tags even from trusted machines, because they allow
> for submitters to add comments directly for the merge, but for
> untrusted general hosting sites I will simply refuse to pull without
> them.

Ok, I have pushed a signed tag "lzo-update-signature-20130226", but
I'm not fully sure if that worked - at least

  $  git verify-tag lzo-update-signature-20130226
  gpg: Signature made Tue 26 Feb 2013 08:39:14 PM CET using DSA key ID 0B2043C9
  gpg: Good signature from "Markus F.X.J. Oberhumer <markus@oberhumer.com>"

and the tag does show up at

  https://github.com/markus-oberhumer/linux/commits/lzo-update-signature-20130226

My public key 0B2043C9 is available on many PGP key servers, e.g.

  http://pgp.mit.edu:11371/pks/lookup?search=markus+oberhumer

Cheers,
Markus

> 
>                 Linus
> 

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
