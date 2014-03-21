Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbaCUOkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:40:55 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:38091 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaCUOku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:40:50 -0400
Date: Fri, 21 Mar 2014 22:40:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S.Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] Fix late crypto work queue initialization
Message-ID: <20140321144040.GD25820@gondor.apana.org.au>
References: <1395100347.2970.14.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395100347.2970.14.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:52:26PM -0700, Tim Chen wrote:
> The crypto algorithm modules utilizing the crypto daemon could
> be used early when the system start up.  Using module_init
> does not guarantee that the daemon's work queue is initialized
> when the cypto alorithm depending on crypto_wq starts.  It is necessary
> to initialize the crypto work queue earlier at the subsystem
> init time to make sure that it is initialized
> when used.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
