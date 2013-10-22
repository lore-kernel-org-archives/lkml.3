Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3JVLaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:30:00 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38527 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3JVL36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:29:58 -0400
MIME-Version: 1.0
In-Reply-To: <20131022052458.GA5896@gondor.apana.org.au>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1382395388-8108-2-git-send-email-zohar@linux.vnet.ibm.com>
	<20131022052458.GA5896@gondor.apana.org.au>
Date: Tue, 22 Oct 2013 12:29:56 +0100
Message-ID: <CACE9dm_Qvf5YaVvxDiDTMfAzZPA0hfqHOTxmvzUeEXCePUdJ2g@mail.gmail.com>
Subject: Re: [PATCH v2 01/23] crypto: provide single place for hash algo information
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 6:24 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Oct 21, 2013 at 06:42:46PM -0400, Mimi Zohar wrote:
>> From: Dmitry Kasatkin <d.kasatkin@samsung.com>
>>
>> This patch provides a single place for information about hash algorithms,
>> such as hash sizes and kernel driver names, which will be used by IMA
>> and the public key code.
>>
>> Changelog:
>> - Fix sparse and checkpatch warnings
>> - Move hash algo enums to uapi for userspace signing functions.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
>
> Are you adding a user-space interface for this? If so please use
> the existing crypto user-space API.
>

Hello,

We are not adding user-space interface.
We just need to algo definitions which are in sync between user space,
IMA/EVM and kernel module signing.
Module signing perl script uses hard coded values. We want to improve
it export them to user space.

But please give us a hint, what crypto user-space API helps for us?

Thanks!

Dmitry


> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
Dmitry
