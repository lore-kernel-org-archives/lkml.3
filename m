Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032AbaKWLv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 06:51:56 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:52382
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbaKWLvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 06:51:54 -0500
X-IronPort-AV: E=Sophos;i="5.07,442,1413237600"; 
   d="scan'208";a="90091333"
Date: Sun, 23 Nov 2014 12:51:51 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Dan Carpenter <dan.carpenter@oracle.com>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [Cocci] [PATCH 1/1] kernel-audit: Deletion of an unnecessary
 check before the function call "audit_log_end"
In-Reply-To: <5469B836.8030507@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1411231249310.2261@localhost6.localdomain6>
References: <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <54687F1A.1010809@users.sourceforge.net> <20141116111023.GA4905@mwanda> <20141116111446.GA4956@mwanda> <54688F15.9070703@users.sourceforge.net> <20141117073408.GC4905@mwanda> <5469B836.8030507@users.sourceforge.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No, it's not.  You should just try to write the most readable software
> > you can instead of removing if statements because you can.
> 
> Additional safety checks have also got an effect on source code readability, haven't they?

Normally, tests only hurt readability if they cannot be false or cannot be 
true.  Making a choice apparent when there really is a choice would seem 
to aid understanding.  Program analysis tools can also potentially exploit 
this information, which you are so systmatically removing.

julia
