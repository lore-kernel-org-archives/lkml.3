Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbaLBHiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:38:06 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:22408 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932369AbaLBHiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:38:04 -0500
X-IronPort-AV: E=Sophos;i="5.07,499,1413237600"; 
   d="scan'208";a="110617368"
Date: Tue, 2 Dec 2014 08:37:32 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2] fs-fat: Less function calls in fat_fill_super() after
 error detection
In-Reply-To: <20141202073440.GH4994@mwanda>
Message-ID: <alpine.DEB.2.02.1412020836040.1984@localhost6.localdomain6>
References: <5467B12C.4010602@users.sourceforge.net> <alpine.DEB.2.02.1411152117540.2225@localhost6.localdomain6> <54796B5E.5040707@users.sourceforge.net> <87sih22sn8.fsf@devron.myhome.or.jp> <alpine.DEB.2.10.1411291338530.2378@hadrien> <87lhmu2jl8.fsf@devron.myhome.or.jp>
 <20141201065221.GA4994@mwanda> <547C89A4.40002@users.sourceforge.net> <20141201191723.GG4994@mwanda> <547CDC1E.7020404@users.sourceforge.net> <20141202073440.GH4994@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2014, Dan Carpenter wrote:

> On Mon, Dec 01, 2014 at 10:22:38PM +0100, SF Markus Elfring wrote:
> > >> Which names would be better acceptable for you?
> > > 
> > > You named it after the goto location but the label name should be based
> > > on the label location to say what the goto does.
> > 
> > I find it easier occasionally to name a label similarly to the jump target.
> 
> That is a useless thing to do.
> 
> > It seems that there are a few variations used for the affected identifiers.
> 
> There is a lot of crap code in the kernel, yes.

Does the label naming strategy appear in the conding style documentation 
anywhere?  There are so many variants that just from looking at the code, 
it is hard to guess what is the best strategy.  For example, out1, out2, 
etc are pretty uninformative, but they are concise and easy to spell 
correctly.

julia
