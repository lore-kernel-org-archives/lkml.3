Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaJCMyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:54:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64510 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaJCMx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:53:58 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-45-542e9c639766
Message-id: <542E9C65.4030208@samsung.com>
Date: Fri, 03 Oct 2014 15:53:57 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 3/4] module: search the key only by keyid
References: <6d32cecfb3c3f5d041900ce1866bc15134832991.1412327306.git.d.kasatkin@samsung.com>
 <cover.1412327306.git.d.kasatkin@samsung.com>
 <cover.1412327306.git.d.kasatkin@samsung.com>
 <29146.1412340378@warthog.procyon.org.uk> <542E9B68.1010906@samsung.com>
In-reply-to: <542E9B68.1010906@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xq7rJc/RCDPb2mVu8a/rNYvFlaZ3F
	uvWLmSxm73rIYvFyxjx2i8u75rBZfOh5xGZxc9oFFotPKyYxO3B67Jx1l91j2ollLB4PDm1m
	8di94DOTR8/3ZI/3+66yeazYcILZ4/MmuQCOKC6blNSczLLUIn27BK6MNV+fshec4qr49Gwe
	UwPjPY4uRk4OCQETiSMH3rNC2GISF+6tZ+ti5OIQEljKKNH4Zi0jhNPIJPF2y3UoZxajxK//
	39lAWngFtCR2dexjB7FZBFQlHq14yAxiswnoSWxo/gEWFxWIkDh5dw87RL2gxI/J91hAbBEB
	dYlHyzYygwxlFnjNKLHxygewO4QFbCWedB2EuqOTSWLrgj6wDk4BbYlZtyczdTFyAHXoSdy/
	qAUSZhaQl9i85i3YYiGgI7rXrmWD+EdR4vTkc8wTGIVnIdk9C6F7FpLuBYzMqxhFU0uTC4qT
	0nON9IoTc4tL89L1kvNzNzFC4uvrDsalx6wOMQpwMCrx8H64oRsixJpYVlyZe4hRgoNZSYRX
	ukkvRIg3JbGyKrUoP76oNCe1+BAjEwenVAPjoUnXV67LujdLpS1P2k7Zf9tSfSHp8o7ldlM9
	dR1kZvVunJbhclpdM7VMpuFQicORgIXcDP//n52/kfv29+5exXRbvuMfNq7n/ManwpPM+Mja
	1+xzicCzGSaBbq/9uZzcHr0LaD6Q8VNrSv0CtqxWt0U7DlQ7RW7Y6NjA+Gpz6TLhid2it7mU
	WIozEg21mIuKEwEPQesyjQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 15:49, Dmitry Kasatkin wrote:
> On 03/10/14 15:46, David Howells wrote:
>> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>>
>>> Latest KEYS code change the way keys identified and module
>>> signing keys are not searchable anymore with original id.
>>>
>>> This patch fixes this problem without change module signature
>>> data.
>> This isn't sufficient.  The key search must also include the signer.
>>
> IMA uses "id:<id>" partial matching.. There is no signer in the signature.
> It is added as "last resort"
>
> It is here... the same but I renamed with finger print..
>
> http://git.kernel.org/cgit/linux/kernel/git/kasatkin/linux-digsig.git/commit/?h=keys-fixes&id=f036bb9a4c1b3c548f315226d3284e6a91d284e7
>
> - Dmitry
>
>

For module actually I made it as a fix because it was broken.
Other requires changes in module signature format...

- Dmitry

>> David
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

