Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3J2Ihf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:37:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34665 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3J2Iha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:37:30 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-08-526f73c7e34b
Message-id: <526F73B1.6030607@samsung.com>
Date: Tue, 29 Oct 2013 10:37:05 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: linux-next: manual merge of the security tree with the  tree
References: <20131028184740.ee58871cc5bd149901cbdf03@canb.auug.org.au>
In-reply-to: <20131028184740.ee58871cc5bd149901cbdf03@canb.auug.org.au>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xq7rHi/ODDE5eNLX4/2E3o0X3KxmL
	desXM1lc3jWHzeLgwjZGi617r7JbfFoxidmB3aPxxg02j20HVD3uXNvD5vHg0GYWj57vyR6f
	N8kFsEVx2aSk5mSWpRbp2yVwZdxfvYGx4A1zxd5zZ1kbGNuZuxg5OSQETCSu7Glnh7DFJC7c
	W8/WxcjFISSwlFFixYrVUE4jk8TnrU+hnLmMEm+fXWUCaeEV0JJ4+xBiFIuAqsTdiU/AbDYB
	PYkNzT/AxooKhEkcbfrJClEvKPFj8j0WEFtEwFeiae5mRpChzAL7GSX+TLgLVMTBISzgKdHX
	aAdiCgm4SaxbmwBSzingLvF7825GEJtZQEdif+s0NghbXmLzmrdga4WATuheu5YN4htFidOT
	zzFPYBSehWTzLCTts5C0L2BkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREjNfdjAuPmZ1
	iFGAg1GJh9eCLT9IiDWxrLgy9xCjBAezkgjvjmCgEG9KYmVValF+fFFpTmrxIUYmDk6pBsZZ
	Od2e/JIcgfURgnnhtbUnF0grTrSMu/SuR7L2ZOUqZpPJO/fbx/kcWCP46UBIzqUjL66KXSst
	3bf4smda4w3Pre2SteVHmTWFt7uuq3fgTJiZahz36vj7tdG726Mm3vnc+7fVZFq1/O/TU6Rt
	5uYLPT/FeGfS7TnHck60ac9SCTfiqXvEKavEUpyRaKjFXFScCACrfgoBdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/13 09:47, Stephen Rothwell wrote:
> Hi James,
>
> Today's linux-next merge of the security tree got a conflict in
> crypto/Makefile between commit a62b01cd6cc1 ("crypto: create generic
> version of ablk_helper") from the crypto tree and commit ee08997fee16
> ("crypto: provide single place for hash algo information") from the
> security tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>
Hello,

Thanks!

- Dmitry

