Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3JVMxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:53:19 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:48987 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752399Ab3JVMxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:53:15 -0400
Date: Tue, 22 Oct 2013 20:53:04 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 01/23] crypto: provide single place for hash algo
 information
Message-ID: <20131022125304.GA10008@gondor.apana.org.au>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1382395388-8108-2-git-send-email-zohar@linux.vnet.ibm.com>
 <20131022052458.GA5896@gondor.apana.org.au>
 <CACE9dm_Qvf5YaVvxDiDTMfAzZPA0hfqHOTxmvzUeEXCePUdJ2g@mail.gmail.com>
 <20131022113203.GA8965@gondor.apana.org.au>
 <CACE9dm-m4f7LYuTADmn_upUEoMjDUKMTBXdnKT=9j+RiqWSp4Q@mail.gmail.com>
 <20131022120704.GA9375@gondor.apana.org.au>
 <1382446213.7734.18.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382446213.7734.18.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 08:50:13AM -0400, Mimi Zohar wrote:
>
> Files, including kernel modules, are already signed in userspace and
> verified by the kernel.  So they already need to be in sync.  Up to now,
> IMA was limited to a 20 byte digest.  This patch set adds support in IMA
> for larger digests.

As you've already added the kernel/user-space interface then there's
not much we can do.  So fine you can add my ack to your patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
