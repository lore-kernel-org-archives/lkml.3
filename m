Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaKLVkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:40:43 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:2336 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbaKLVkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:40:40 -0500
X-IronPort-AV: E=Sophos;i="5.07,371,1413237600"; 
   d="scan'208";a="106413368"
Date: Wed, 12 Nov 2014 22:40:34 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 1/2] staging: rtl8188eu: Deletion of unnecessary checks
 before three function calls
In-Reply-To: <5463D109.4020702@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1411122237380.2055@localhost6.localdomain6>
References: <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <544954FD.8040607@users.sourceforge.net>
 <20141029084702.GA18675@kroah.com> <5453CD0D.9010206@users.sourceforge.net> <alpine.DEB.2.10.1410311900201.2481@hadrien> <5463C10D.6020409@users.sourceforge.net> <5463C22B.7060405@users.sourceforge.net> <20141112211815.GJ6749@mwanda>
 <5463D109.4020702@users.sourceforge.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is especially true if you have trained yourself to know that
> > free_netdev() can't accept NULL pointers.
> 
> Do you need to adjust your concerns a bit over time when function variants
> provide a corresponding safety check in their implementations?

There would not seem to be any _need_ to do so.  An unnecessary null test 
is always safe.  The only real problem that I can see with an unnecessary 
null test in error handling code (intrinsically not critical performance 
wise) is if it gives the illusion that a value can be null when it cannot.

julia
