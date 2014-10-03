Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaJCMts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:49:48 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35043 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaJCMtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:49:45 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-32-542e9b6730c4
Message-id: <542E9B68.1010906@samsung.com>
Date: Fri, 03 Oct 2014 15:49:44 +0300
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
 <29146.1412340378@warthog.procyon.org.uk>
In-reply-to: <29146.1412340378@warthog.procyon.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xK7rps/VCDO59ZLJ41/SbxeLL0jqL
	desXM1nM3vWQxeLljHnsFpd3zWGz+NDziM3i5rQLLBafVkxiduD02DnrLrvHtBPLWDweHNrM
	4rF7wWcmj57vyR7v911l81ix4QSzx+dNcgEcUVw2Kak5mWWpRfp2CVwZF5ZfYC5YwF6xf+Zi
	9gbGRrYuRg4OCQETiRPTGbsYOYFMMYkL99YDhbk4hASWMkrc23iEBcJpZJKYt2AZlDOLUaLv
	8QUmkBZeAS2Jae/+sYDYLAKqEvPebgGz2QT0JDY0/2AHsUUFIiRO3t3DDlEvKPFj8j2wGhEB
	dYlHyzYygwxlFnjNKLHxygdWkISwgK3Ek66DbCC2kMArRolzPeogNqeAmcTZNR2sIGczAy24
	f1ELJMwsIC+xec1bZohyVYnutWvZIN5RlDg9+RzzBEbhWUhWz0LonoWkewEj8ypG0dTS5ILi
	pPRcQ73ixNzi0rx0veT83E2MkNj6soNx8TGrQ4wCHIxKPLwfb+iGCLEmlhVX5h5ilOBgVhLh
	lW7SCxHiTUmsrEotyo8vKs1JLT7EyMTBKdXAyJuqPFt+pbH668CJWzNWHp0WuGVaVN9bz4om
	1eDIBZ1KH/9EmCb/mGZwJNZh6wrttM+/lkkvkzBsVtkdliyU8nGR/ZfLddM1ZDXLsmufW7Oo
	/G/jOOHr5KTG/y1xEaNEftOdw47KL1cZxc4S150wmetgC6fSmtNHj/7/k3kq/oODfuMG2S99
	SizFGYmGWsxFxYkAnYcsK4sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 15:46, David Howells wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> Latest KEYS code change the way keys identified and module
>> signing keys are not searchable anymore with original id.
>>
>> This patch fixes this problem without change module signature
>> data.
> This isn't sufficient.  The key search must also include the signer.
>

IMA uses "id:<id>" partial matching.. There is no signer in the signature.
It is added as "last resort"

It is here... the same but I renamed with finger print..

http://git.kernel.org/cgit/linux/kernel/git/kasatkin/linux-digsig.git/commit/?h=keys-fixes&id=f036bb9a4c1b3c548f315226d3284e6a91d284e7

- Dmitry


> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

