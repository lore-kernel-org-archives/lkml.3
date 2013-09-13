Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3IMMX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:23:27 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:45265 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846Ab3IMMX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:23:26 -0400
Date: Fri, 13 Sep 2013 22:23:09 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Matt Mackall <mpm@selenic.com>, kbuild test robot <fengguang.wu@intel.com>,
        kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwrng: via-rng: Mark device ID table as __maybe_unused
Message-ID: <20130913122309.GC8579@gondor.apana.org.au>
References: <1378338372.27597.4.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378338372.27597.4.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 12:46:12AM +0100, Ben Hutchings wrote:
> It is only used in modular builds.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
