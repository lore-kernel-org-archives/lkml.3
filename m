Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161112AbaDPNsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:48:24 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:47896 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbaDPNsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:48:22 -0400
Date: Wed, 16 Apr 2014 21:48:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: rcj@linux.vnet.ibm.com, mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/crypto: Use RCU_INIT_POINTER(x, NULL) in
 nx/nx-842.c
Message-ID: <20140416134811.GA4684@gondor.apana.org.au>
References: <1395603162-16746-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395603162-16746-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 01:02:42AM +0530, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
> 
> The rcu_assign_pointer() ensures that the initialization of a structure       
> is carried out before storing a pointer to that structure. 
> And in the case of the NULL pointer, there is no structure to initialize. 
> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
