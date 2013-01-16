Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab3APGVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:21:10 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:35019 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab3APGVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:21:07 -0500
Date: Wed, 16 Jan 2013 07:21:04 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: IPsec AH use of ahash
Message-ID: <20130116062104.GA18940@secunet.com>
References: <528051367.70594.1358268708738.JavaMail.root@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528051367.70594.1358268708738.JavaMail.root@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 16 Jan 2013 06:21:04.0757 (UTC) FILETIME=[A9D34A50:01CDF3B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc netdev@vger.kernel.org on all networking related topics.

On Tue, Jan 15, 2013 at 11:51:48AM -0500, Tom St Denis wrote:
> Hi all,
> 
> The AH4/6 code uses ahash to perform the MAC calculation but this precludes the availability of GMAC to the user.  Are there any plans to port the AH code over to the aead API so that it can use potentially any algo available to the user?
> 

There was no need for this by now, but you are welcome
to send patches.
