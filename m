Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbaFQTVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:21:06 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55752 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932930AbaFQTVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:21:03 -0400
X-Sasl-enc: hz7cXNBdj9OFS0G+OGyoPFpuHSN9AkfLvNY17zhDfB+H 1403032857
Date: Tue, 17 Jun 2014 12:24:48 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/24] crypt: return actual error code on pcrypt_init
Message-ID: <20140617192448.GD4628@kroah.com>
References: <53A050AE.2050401@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A050AE.2050401@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:29:02PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Return the actual error code if call kset_create_and_add() failed
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller" <davem@davemloft.net>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  crypto/pcrypt.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Herbert and David, please do not take this patch, it is incorrect.

thanks,

greg k-h
