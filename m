Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaKWPv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:51:57 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:11808 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbaKWPv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:51:56 -0500
X-IronPort-AV: E=Sophos;i="5.07,443,1413237600"; 
   d="scan'208";a="109099980"
Date: Sun, 23 Nov 2014 16:51:53 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Joe Perches <joe@perches.com>, Andreas Noever <andreas.noever@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: thunderbolt: Deletion of unnecessary checks before the function
 call "ring_free"
In-Reply-To: <54720061.7010401@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1411231650580.2037@localhost6.localdomain6>
References: <5307CAA2.8060406@users.sourceforge.net>  <530A72AA.3000601@users.sourceforge.net>  <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>  <530B5FB6.6010207@users.sourceforge.net>  <alpine.DEB.2.10.1402241710370.2074@hadrien> 
 <530C5E18.1020800@users.sourceforge.net>  <alpine.DEB.2.10.1402251014170.2080@hadrien>  <530CD2C4.4050903@users.sourceforge.net>  <alpine.DEB.2.10.1402251840450.7035@hadrien>  <530CF8FF.8080600@users.sourceforge.net>  <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
  <530DD06F.4090703@users.sourceforge.net>  <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>  <5317A59D.4@users.sourceforge.net> <546F16A5.8030405@users.sourceforge.net>  <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com> 
 <546F2E50.5040804@users.sourceforge.net>  <1416593688.6651.39.camel@perches.com>  <5471EBAC.40903@users.sourceforge.net> <1416756022.6651.45.camel@perches.com> <54720061.7010401@users.sourceforge.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Nov 2014, SF Markus Elfring wrote:

> >> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/char/tpm/xen-tpmfront.c?id=fc14f9c1272f62c3e8d01300f52467c0d9af50f9#n268
> > 
> > I think static functions can be named whatever
> > the developer chooses.
> 
> I agree also that this implementation detail is correct in principle.
> 
> Is a renaming of such identifiers feasible so that the probability of
> other name clashes can be reduced and corresponding static source
> code analysis might become a bit easier?

Why not just make the static source code analysis aware of the problem?  
You can treat static functions differently that non-static ones.  There is 
no need to change the code.

julia
