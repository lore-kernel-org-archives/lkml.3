Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3ETQvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:51:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:11002 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab3ETQvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:51:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,709,1363158000"; 
   d="scan'208";a="337105589"
Date: Mon, 20 May 2013 09:51:29 -0700
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.9-stable] ntb: off by one sanity checks
Message-ID: <20130520165129.GD31363@jonmason-lab>
References: <1368844538-3841-1-git-send-email-jhbird.choi@samsung.com>
 <20130518144709.GA29066@jonmason-lab>
 <20130520163850.GA28172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520163850.GA28172@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 09:38:50AM -0700, Greg KH wrote:
> On Sat, May 18, 2013 at 07:47:09AM -0700, Jon Mason wrote:
> > On Sat, May 18, 2013 at 11:35:38AM +0900, Jonghwan Choi wrote:
> > > From: Dan Carpenter <dan.carpenter@oracle.com>
> > > 
> > > This patch looks like it should be in the 3.9-stable tree, should we apply
> > > it?
> > 
> > Yes, please do.  I'll respond to each of the patch series, but please
> > apply them all.  Also, one patch was omitted from these, titled 
> > NTB: variable dereferenced before check
> > 
> > Please include that patch in 3.9 stable as well.
> 
> Can you just send me the git commit ids of the patches you wish to see
> applied to the stable tree, and the order in which they need to go in?

My apologies.  All the commits to Linus' tree were bug fixes, so all
of them should be pulled.  You can get them at:

git://github.com/jonmason/ntb.git tags/ntb-bugfixes-3.10

or, if you just want the commit ids (in order of oldest to newest)

186f27ff9f9ec5c110739ced88ce9f8fca053882
ad3e2751e7c546ae678be1f8d86e898506b42cef
cc0f868d8adef7bdc12cda132654870086d766bc
113fc505b83b2d16e820ca74fa07f99a34877b1d
b77b2637b39ecc380bb08992380d7d48452b0872
90f9e934647e652a69396e18c779215a493271cf
c9d534c8cbaedbb522a1d2cb037c6c394f610317
c336acd3331dcc191a97dbc66a557d47741657c7
904435cf76a9bdd5eb41b1c4e049d5a64f3a8400
8b19d450ad188d402a183ff4a4d40f31c3916fbf

> Also, in the future, please tag the patches you want in the stable
> releases with the proper "Cc: Stable <stable@vger.kernel.org>" line in
> the signed-off-by: area of the patch, so I can pick it up automagically.

Will do.

Thanks,
Jon

> thanks,
> 
> greg k-h
