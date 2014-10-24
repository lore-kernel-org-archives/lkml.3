Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbaJXOyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:54:14 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:41847 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJXOyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:54:12 -0400
Date: Fri, 24 Oct 2014 22:54:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: standby24x7@gmail.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Remove unnecessary KERN_INFO from testmgr.c
Message-ID: <20141024145408.GA21055@gondor.apana.org.au>
References: <1412609874-22311-1-git-send-email-standby24x7@gmail.com>
 <20141006.152251.1468043820451352291.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006.152251.1468043820451352291.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 03:22:51PM -0400, David Miller wrote:
> From: Masanari Iida <standby24x7@gmail.com>
> Date: Tue,  7 Oct 2014 00:37:54 +0900
> 
> > This patch remove unncessary KERN_INFO from pr_info within testmgr.c
> > 
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
