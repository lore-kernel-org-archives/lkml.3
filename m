Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaKNKbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:31:48 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:50194 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754792AbaKNKbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:31:46 -0500
X-IronPort-AV: E=Sophos;i="5.07,385,1413237600"; 
   d="scan'208";a="106851392"
Date: Fri, 14 Nov 2014 11:31:30 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Joe Perches <joe@perches.com>, Coccinelle <cocci@systeme.lip6.fr>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cocci] spatch for trivial pointer comparison style?
In-Reply-To: <5465D4B2.4020000@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1411141130470.2443@hadrien>
References: <1415908529.4223.11.camel@perches.com> <alpine.DEB.2.02.1411140700010.2035@localhost6.localdomain6> <5465D4B2.4020000@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, SF Markus Elfring wrote:

> > I don't think that the change is desirable in all cases.  There are
> > functions like kmalloc where NULL means failure and !p seems like the
> > reasonable choice.  But there maybe other cases where NULL is somehow
> > a meaningful value.
>
> How do you think about to adjust checks for null pointers not only
> in Linux source files but also in other applications?
> Are there any more software design challenges to consider with the
> definition of the preprocessor symbol "NULL"?

Other applications may have other preferences.

julia
