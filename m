Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaD0Jg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 05:36:28 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:29885
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753145AbaD0Jg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 05:36:27 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389740400"; 
   d="scan'208";a="59185522"
Date: Sun, 27 Apr 2014 11:36:22 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Javier Martinez Canillas <javier@dowhile0.org>
cc: Wolfram Sang <wsa@the-dreams.de>, Michal Marek <mmarek@suse.cz>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [Cocci] [PATCH 1/1] scripts/coccinelle: use BIT() macro if
 possible
In-Reply-To: <CABxcv==8F2CghQKVDp==5Mx8-OBJnc+yZWEBqi7OFGij8OHaeg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1404271135590.2006@localhost6.localdomain6>
References: <1398558586-28931-1-git-send-email-javier@dowhile0.org> <20140427051428.GA2671@katana> <CABxcv==8F2CghQKVDp==5Mx8-OBJnc+yZWEBqi7OFGij8OHaeg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Apr 2014, Javier Martinez Canillas wrote:

> Hello Wolfram,
> 
> Thanks a lot for your feedback.
> 
> On Sun, Apr 27, 2014 at 7:14 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > On Sun, Apr 27, 2014 at 02:29:46AM +0200, Javier Martinez Canillas wrote:
> >> Using the BIT() macro instead of manually shifting bits
> >> makes the code less error prone and also more readable.
> >
> > Does it? It is a taste thing, yet I don't think it makes the code that
> > much more readable that it is worth changing the whole tree.
> >
> 
> I believe there is a reason for that macro but yes I agree with you
> that is a matter of taste and the it shouldn't be enforced.
> 
> I'm doing a big refactoring for the GPIO subsystem and was told to use
> coccinelle so this patch was part of my learning. I posted it because
> I thought that it could be useful but I don't mind the patch to be
> dropped if that is not the case.

Perhaps it could be useful in files that already use BIT somewhere?

julia
