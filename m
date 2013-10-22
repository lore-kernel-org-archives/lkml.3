Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab3JVFZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 01:25:56 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:43598 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750842Ab3JVFZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 01:25:55 -0400
Date: Tue, 22 Oct 2013 13:24:59 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 01/23] crypto: provide single place for hash algo
 information
Message-ID: <20131022052458.GA5896@gondor.apana.org.au>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1382395388-8108-2-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382395388-8108-2-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 06:42:46PM -0400, Mimi Zohar wrote:
> From: Dmitry Kasatkin <d.kasatkin@samsung.com>
> 
> This patch provides a single place for information about hash algorithms,
> such as hash sizes and kernel driver names, which will be used by IMA
> and the public key code.
> 
> Changelog:
> - Fix sparse and checkpatch warnings
> - Move hash algo enums to uapi for userspace signing functions.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

Are you adding a user-space interface for this? If so please use
the existing crypto user-space API.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
