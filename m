Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaENLpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:45:46 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:58869 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbaENLpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:45:45 -0400
Date: Wed, 14 May 2014 13:45:38 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Fabian Frederick <fabf@skynet.be>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        akpm <akpm@linux-foundation.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] net/xfrm/xfrm_output.c: move EXPORT_SYMBOL
Message-ID: <20140514114538.GA32371@secunet.com>
References: <20140512195434.ae5e323fe8394354b224a03e@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140512195434.ae5e323fe8394354b224a03e@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.182.7.102]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc netdev@vger.kernel.org on all future networking patches.

On Mon, May 12, 2014 at 07:54:34PM +0200, Fabian Frederick wrote:
> Fix checkpatch warning:
> "WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable"
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied to ipsec-next, thanks!

