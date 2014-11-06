Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaKFPRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:17:11 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:34320 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaKFPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:17:07 -0500
Date: Thu, 6 Nov 2014 23:17:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/9] NX crypto driver fixes
Message-ID: <20141106151704.GD4544@gondor.apana.org.au>
References: <20141028174006.GA15893@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028174006.GA15893@bluepex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:40:09PM -0200, Leonidas S. Barbosa wrote:
> This patch set fixes the follow issues in  NX crypto driver:
> 
>   - Bound limit issue that causes a memory crash
>   - SHA concurrence issue
>   - IV vector fix with the correct bit order
>   - NX CCM does not support keys larger than 128 causing
>   crashes in fips mode.

All applied except the last patch.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
