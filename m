Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3JFNxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 09:53:49 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:44989 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647Ab3JFNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 09:53:48 -0400
X-IronPort-AV: E=Sophos;i="4.90,1044,1371074400"; 
   d="scan'208";a="35771322"
Date: Sun, 6 Oct 2013 15:53:27 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Wolfram Sang <wsa@the-dreams.de>
cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr
Subject: Re: [PATCH] scripts/coccinelle/api: remove
 devm_request_and_ioremap.cocci
In-Reply-To: <20131006134921.GA4173@katana>
Message-ID: <alpine.DEB.2.02.1310061552541.2037@localhost6.localdomain6>
References: <1376562633-16204-1-git-send-email-wsa@the-dreams.de> <20131006134921.GA4173@katana>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Oct 2013, Wolfram Sang wrote:

> On Thu, Aug 15, 2013 at 12:30:25PM +0200, Wolfram Sang wrote:
> > Use of this function is discouraged in favour of
> > devm_ioremap_resource(). Don't advertise it.
> > 
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> 
> Ping.
> 
> 
