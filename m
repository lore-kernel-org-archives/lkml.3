Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbaGEAgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 20:36:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:41588 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbaGEAgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 20:36:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,604,1400050800"; 
   d="scan'208";a="557619991"
Date: Sat, 5 Jul 2014 08:36:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kbuild@01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] Potential NULL pointer deference in drbg_ctr_df
Message-ID: <20140705003607.GA30874@localhost>
References: <20140620202418.GZ5015@mwanda>
 <20140625090646.GB8727@gondor.apana.org.au>
 <20140704105003.GA25934@mwanda>
 <3313472.TGNVD1jVhQ@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3313472.TGNVD1jVhQ@myon.chronox.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 02:00:15AM +0200, Stephan Mueller wrote:
> Am Freitag, 4. Juli 2014, 13:50:03 schrieb Dan Carpenter:
> 
> Hi Dan,
> 
> > On Wed, Jun 25, 2014 at 05:06:46PM +0800, Herbert Xu wrote:
> > > On Sat, Jun 21, 2014 at 02:26:29PM +0200, Stephan Mueller wrote:
> > > > The handling of additional input data / personalization string data may
> > > > be subject to a NULL pointer deference for the CTR DRBG. The
> > > > caller-provided data may be NULL which must be caught by the DRBG.
> > > > 
> > > > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > 
> > Oh, huh.  This bug was actually reported by me but I forgot to change
> > the from header and apparently my smtp server allows me to send emails
> > as if I work for Intel.  :P
> > 
> > Fengguang is much nicer than I am.  :P
> 
> Too late, your colleague's name is now in the patches ;-)

Thank you nice guys! :P

Thanks,
Fengguang
