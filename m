Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935096Ab3DKRXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:23:13 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33027 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3DKRXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:23:11 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXR-dYRWkkz=V8=zn7cO=G1Ksa0bNweGn6kbYpjPn4mTg@mail.gmail.com>
References: <CA+icZUXR-dYRWkkz=V8=zn7cO=G1Ksa0bNweGn6kbYpjPn4mTg@mail.gmail.com>
Date: Thu, 11 Apr 2013 19:23:09 +0200
Message-ID: <CA+icZUWZ5=c6=+SneWnuC5Qz93ENxRD--DKz-m2VxudUFLyxGA@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 11 [ crypto: aesni-intel ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 7:14 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Apr 11, 2013 at 10:30 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20130410:
>>
>> The tip tree gained conflicts against the net-next and pm trees.
>>
>> The driver-core tree gained a conflict against the tip tree.
>>
>> The arm-soc tree gained a conflict against the arm-current tree.
>>
>> The akpm tree lost a patch that turned up elsewhere.
>>
>> ----------------------------------------------------------------------------
>
> [ CC linux-crypto folks ]
>
> On Ubuntu/precise AMD64 I see:
>
> ERROR: "glue_xts_crypt_128bit_one" [arch/x86/crypto/aesni-intel.ko] undefined!
> ERROR: "glue_xts_crypt_128bit" [arch/x86/crypto/aesni-intel.ko] undefined!
> make[3]: *** [__modpost] Error 1
> make[2]: *** [modules] Error 2
>
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_X86_64=m
> CONFIG_CRYPTO_AES_NI_INTEL=m
>
> Full kernel-config attached.
>
>
> - Sedat -

Trying the fix "crypto: aesni_intel - fix Kconfig problem with
CRYPTO_GLUE_HELPER_X86" from [1].

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=110e7610190cc4693f26c05b43ea83468a0a925c
