Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab3BWPGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 10:06:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29774 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab3BWPGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 10:06:44 -0500
Date: Sat, 23 Feb 2013 18:05:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles.Muller@lip6.fr,
        nicolas.palix@imag.fr, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle: find constant additions that could
 be bit ors
Message-ID: <20130223150521.GK9138@mwanda>
References: <1359821995-27910-1-git-send-email-Julia.Lawall@lip6.fr>
 <20130222104431.GF12402@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222104431.GF12402@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 11:44:31AM +0100, Michal Marek wrote:
> On Sat, Feb 02, 2013 at 05:19:55PM +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Semantic patch (http://coccinelle.lip6.fr/) to check for constants that are
> > added but are used elsewhere as bitmasks.
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Applied to kbuild.git#misc.
> 

I'm not sure we want to do this.  The one patch which was sent with
this script wasn't applied.

regards,
dan carpenter

