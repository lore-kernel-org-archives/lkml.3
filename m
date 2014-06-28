Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbaF1Scu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:32:50 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:49278 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624AbaF1Scs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 14:32:48 -0400
X-IronPort-AV: E=Sophos;i="5.01,567,1400018400"; 
   d="scan'208";a="82700347"
Date: Sat, 28 Jun 2014 20:32:45 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [Cocci] [PATCH V3] scripts/coccinelle/free: Delete NULL test
 before freeing functions?
In-Reply-To: <53AE8613.8080600@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1406282030260.2538@hadrien>
References: <1403945247-21549-1-git-send-email-fabf@skynet.be> <53AE8613.8080600@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jun 2014, SF Markus Elfring wrote:

>
> > V3:
> >    -Update print_main message.
>
> Does the discussion topic need also an adjustment?
>
> How do you think about my previous update suggestion "Deletion of
> unnecessary checks before specific function calls"?
> https://systeme.lip6.fr/pipermail/cocci/2014-March/000675.html
> https://lkml.org/lkml/2014/3/5/344

I would prefer to accept Fabian's semantic patch for the moment, as it
considers a more restricted, well thought out, set of functions,

julia
