Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3FGQwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:52:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:24424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab3FGQwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:52:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,823,1363158000"; 
   d="scan'208";a="325882221"
Subject: Re: [PATCH] Fix prototype definitions of sha256_transform_asm,
 sha512_transform_asm
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S.Miller" <davem@davemloft.net>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
In-Reply-To: <1370623674.27102.376.camel@schen9-DESK>
References: <cover.1364303479.git.tim.c.chen@linux.intel.com>
	 <1364331519.27102.10.camel@schen9-DESK>
	 <1366403112.27102.112.camel@schen9-DESK>
	 <20130425130404.GA29292@gondor.apana.org.au>
	 <1370623674.27102.376.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jun 2013 09:51:59 -0700
Message-ID: <1370623919.27102.378.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 09:47 -0700, Tim Chen wrote:
> On Thu, 2013-04-25 at 21:04 +0800, Herbert Xu wrote:
> > On Fri, Apr 19, 2013 at 01:25:12PM -0700, Tim Chen wrote:
> > > Herbert,
> > > 
> > > This is a follow on patch to the optimized sha256 and sha512 patch series that's just
> > > merged into the crypto-dev.  Let me know if you prefer me to respin the
> > > patch series.
> > > 
> > > This patch corrects the prototype of sha256_transform_asm and
> > > sha512_transform_asm function pointer declaration to static.  It also
> > > fixes a typo in sha512_ssse3_final function that affects the computation
> > > of upper 64 bits of the buffer size.
> > 
> > Thanks, I've folded this into the original patches in order to
> > maintain bisectability.
> 
> Hi Herbert,
> 
> Wonder if you had a chance to merge this patch?  I think it is not in
> the latest crypto-dev.
> 

Actually it has been merged.  The kbuild test robot was picking up an
old tree.

Sorry for the noise.  Thanks.

Tim

