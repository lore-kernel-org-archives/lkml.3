Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab3DCBxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:53:24 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:33225 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753395Ab3DCBxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:53:22 -0400
Date: Wed, 3 Apr 2013 09:53:07 +0800
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
Subject: Re: [PATCH v2 00/10] Optimize SHA256 and SHA512 for Intel x86_64
 with SSSE3, AVX or AVX2 instructions
Message-ID: <20130403015307.GC20205@gondor.apana.org.au>
References: <cover.1364303479.git.tim.c.chen@linux.intel.com>
 <1364331519.27102.10.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364331519.27102.10.camel@schen9-DESK>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 01:58:39PM -0700, Tim Chen wrote:
> Herbert, 
> 
> The following patch series provides optimized SHA256 and SHA512 routines
> using the SSSE3, AVX or AVX2 instructions on x86_64 for Intel cpus.
> Depending on cpu capabilities, speedup between 40% to 70% or more can be achieved
> over the generic SHA256 and SHA512 routines.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
