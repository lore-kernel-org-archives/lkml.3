Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3JVL5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:57:06 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:40521 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3JVL5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:57:03 -0400
MIME-Version: 1.0
In-Reply-To: <20131022113203.GA8965@gondor.apana.org.au>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1382395388-8108-2-git-send-email-zohar@linux.vnet.ibm.com>
	<20131022052458.GA5896@gondor.apana.org.au>
	<CACE9dm_Qvf5YaVvxDiDTMfAzZPA0hfqHOTxmvzUeEXCePUdJ2g@mail.gmail.com>
	<20131022113203.GA8965@gondor.apana.org.au>
Date: Tue, 22 Oct 2013 12:57:02 +0100
Message-ID: <CACE9dm-m4f7LYuTADmn_upUEoMjDUKMTBXdnKT=9j+RiqWSp4Q@mail.gmail.com>
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

On Tue, Oct 22, 2013 at 12:32 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Tue, Oct 22, 2013 at 12:29:56PM +0100, Dmitry Kasatkin wrote:
>>
>> We are not adding user-space interface.
>> We just need to algo definitions which are in sync between user space,
>> IMA/EVM and kernel module signing.
>> Module signing perl script uses hard coded values. We want to improve
>> it export them to user space.
>>
>> But please give us a hint, what crypto user-space API helps for us?
>
> OK, if you're not exporting the kernel asymmetric key code then
> that's fine.
>

Can we take this to mean acked-by you?

Thanks,
Dmitry

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Thanks,
Dmitry
