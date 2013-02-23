Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab3BWQIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 11:08:05 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44369
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649Ab3BWQID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 11:08:03 -0500
X-IronPort-AV: E=Sophos;i="4.84,721,1355094000"; 
   d="scan'208";a="3228574"
Date: Sat, 23 Feb 2013 17:07:58 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Michal Marek <mmarek@suse.cz>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles.Muller@lip6.fr, nicolas.palix@imag.fr, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle: find constant additions that could
 be bit ors
In-Reply-To: <20130223150521.GK9138@mwanda>
Message-ID: <alpine.DEB.2.02.1302231706060.2085@localhost6.localdomain6>
References: <1359821995-27910-1-git-send-email-Julia.Lawall@lip6.fr> <20130222104431.GF12402@pobox.suse.cz> <20130223150521.GK9138@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2013, Dan Carpenter wrote:

> On Fri, Feb 22, 2013 at 11:44:31AM +0100, Michal Marek wrote:
> > On Sat, Feb 02, 2013 at 05:19:55PM +0100, Julia Lawall wrote:
> > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > > 
> > > Semantic patch (http://coccinelle.lip6.fr/) to check for constants that are
> > > added but are used elsewhere as bitmasks.
> > > 
> > > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Applied to kbuild.git#misc.
> > 
> 
> I'm not sure we want to do this.  The one patch which was sent with
> this script wasn't applied.

I think that the view on it was that if it isn't broken, don't fix it.  
But if the rules that are being added to the kernel are primarily being 
used for new code, then it could be reasonable for developers to consider 
whether they would really rather use | rather than the confusing +.

julia
