Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaIHJTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:19:06 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14255 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaIHJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:19:01 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f5-b7f776d000003e54-e4-540d74814207
Message-id: <540D73C9.3000906@samsung.com>
Date: Mon, 08 Sep 2014 12:15:53 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
To: Behan Webster <behanw@converseincode.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: zohar@linux.vnet.ibm.com, james.l.morris@oracle.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, serge@hallyn.com,
        torvalds@linux-foundation.org, Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
References: <1409958360-8061-1-git-send-email-behanw@converseincode.com>
 <alpine.DEB.2.10.1409060131260.5472@nanos>
 <540A590F.1030407@converseincode.com>
 <alpine.DEB.2.10.1409061152090.5472@nanos>
 <540BBD9E.6050708@converseincode.com>
In-reply-to: <540BBD9E.6050708@converseincode.com>
Content-transfer-encoding: 8bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t/xK7qNJbwhBi+ajSxOncmxOPDlMZPF
	lN9zWC26X8lY9D0Osrh/7yeTxcsZ89gtlrRsYbS4vGsOm8WHnkdsFucvnGO32LxpKrPFo763
	7BafVkxiduDz2Nk2n9Vj56y77B4fPsZ5bDug6nFtd6THu3Pn2D1OzPjN4vHg0GYWj90LPjN5
	fHx6i8Xj8ya5AO4oLpuU1JzMstQifbsErozdt1QLXstXPPr/nK2B8YFEFyMnh4SAicTlCyvY
	IWwxiQv31rN1MXJwCAksZZR4kA0S5hUQlPgx+R4LSJhZQF1iypTcLkYuoIpGJomPp+YyQziz
	GCWmHVvNCtGgJXFu9xawmSwCqhKLVkLE2QT0JDY0/wCLiwqESTz7dZAJxBYRCJV4v+Y9G8gg
	ZoHjzBKz9h5gAUkICwRIdG75ygqx4ROjxNcX58Cu4xQwkpj3wxCkhllAXuLgledg9UJAy7rX
	rmWDeEZR4vTkc8wTGIVnIXliFsITs5B0L2BkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kR
	Ep9fdzAuPWZ1iFGAg1GJhzfhKk+IEGtiWXFl7iFGCQ5mJRHe4BzeECHelMTKqtSi/Pii0pzU
	4kOMTBycUg2MWvzfA3q3pn7qkV68+5nD4bRvrU01je+OXbAWktM7aJU9p1xe9sTOSe+2WB+O
	lPdxuPR41g+WVzXB59N5lVc8DON5U/1+w5qPaVduX/jy+FWBxs8zEx3TnnnvW+UXvmTapr9b
	wz32LfaPla8v9N3MEvMp6/XUgv9SZ11di2c6//7z84Lj4lpDcyWW4oxEQy3mouJEAMfmr4qt	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 05:06, Behan Webster wrote:
> On 09/06/14 03:11, Thomas Gleixner wrote:
>> On Fri, 5 Sep 2014, Behan Webster wrote:
>>> On 09/05/14 17:18, Thomas Gleixner wrote:
>>>>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>>>>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>>>>> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
>>>> This SOB chain is completely ass backwards. See Documentation/...
>>> "The Signed-off-by: tag indicates that the signer was involved in the
>>> development of the patch, or that he/she was in the patch's delivery
>>> path."
>>>
>>> All three of us were involved. Does that not satisfy this rule?
>> No. Read #12
>>
>> The sign-off is a simple line at the end of the explanation for the
>> patch, which certifies that you wrote it or otherwise have the right to
>> pass it on as an open-source patch.
>>
>> So the above chain says:
>>
>>     Written-by:   Behan
>>     Passed-on-by: Mark
>>     Passed-on-by: Jan
>>
>> That would be correct if you sent the patch to Mark, Mark sent it to
>> Jan and Jan finally submitted it to LKML.
> I suppose "Reviewed-by" is probably more appropriate for the last 2
> then. Will fix.
>
>>>>> -    struct {
>>>>> -        struct shash_desc shash;
>>>>> -        char ctx[crypto_shash_descsize(tfm)];
>>>>> -    } desc;
>>>>> +    char desc[sizeof(struct shash_desc) +
>>>>> +        crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
>>>>> +    struct shash_desc *shash = (struct shash_desc *)desc;
>>>> That anon struct should have never happened in the first place.
>>> Sadly this is a design pattern used in many places through out the
>>> kernel, and
>>> appears to be fundamental to the crypto system. I was advised *not*
>>> to change
>>> it, so we haven't.
>>>
>>> I agree that it's not a good practice.
>>>
>>>>    Not
>>>> your problem, but you are not making it any better. You replace open
>>>> coded crap with even more unreadable crap.
>>>>
>>>> Whats wrong with
>>>>
>>>>         SHASH_DESC_ON_STACK(shash, tfm);
>>> Nothing is wrong with that. I would have actually preferred that.
>>> But it would
>>> have fundamentally changed a lot more code.
>> Errm. Why is
>>
>> #define SHASH_DESC_ON_STACK(shash, tfm)                \
>>     char __shash[sizeof(.....)];                \
>>     struct shash_desc *shash = (struct shash_desc *) __shash
>>
>> requiring more fundamental than open coding the same thing a gazillion
>> times. You still need to change ALL usage sides of the anon struct.
>>
>> So in fact you could avoid the whole code change by making it
>>
>>     SHASH_DESC_ON_STACK(desc, tfm);
>>
>> and do the anon struct or a proper struct magic in the macro.
> I see. I thought you meant a more fundamental change to the crypto
> system API. My misunderstanding.
>
> Ironically we tried to stay away from macros since the last time we
> tried to replace VLAIS using macros (we've attempted patches to remove
> VLAIS a few times) we were told *not* to hide the implementation with
> macro magic. Though, to be fair, we were using more pointer math in
> our other macro-based effort, and the non-crypto uses of VLAIS are a
> lot more complex to replace.
>
> Like I said I'm actually a fan of hiding ugliness in macros. Will fix.
>
> Again, thanks for the feedback,
>
> Behan
>

Hi,

Despite if it is crap or not, it was said already in this thread,
following "design pattern" is heavily used through out the kernel - by
crypto core itself and by many widely used clients.

    struct {
        struct shash_desc shash;
        char ctx[crypto_shash_descsize(tfm)];
    } desc;


My question why do you want to change this particular piece of code?
What about rest of the kernel?
To solve your problem you probably need to change everything.

If we are going to change it and introduce any macros, it is better to
do with the guidance from crypto folks.

I added CC:linux-crypto@vger.kernel.org mailing list and Herbert Xu,
crypto maintainer.

- Dmitry

