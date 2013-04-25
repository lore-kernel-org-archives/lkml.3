Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3DYNE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:04:28 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:35013 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758539Ab3DYNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:04:25 -0400
Date: Thu, 25 Apr 2013 21:04:04 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S.Miller" <davem@davemloft.net>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Fix prototype definitions of sha256_transform_asm,
 sha512_transform_asm
Message-ID: <20130425130404.GA29292@gondor.apana.org.au>
References: <cover.1364303479.git.tim.c.chen@linux.intel.com>
 <1364331519.27102.10.camel@schen9-DESK>
 <1366403112.27102.112.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366403112.27102.112.camel@schen9-DESK>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 01:25:12PM -0700, Tim Chen wrote:
> Herbert,
> 
> This is a follow on patch to the optimized sha256 and sha512 patch series that's just
> merged into the crypto-dev.  Let me know if you prefer me to respin the
> patch series.
> 
> This patch corrects the prototype of sha256_transform_asm and
> sha512_transform_asm function pointer declaration to static.  It also
> fixes a typo in sha512_ssse3_final function that affects the computation
> of upper 64 bits of the buffer size.

Thanks, I've folded this into the original patches in order to
maintain bisectability.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
