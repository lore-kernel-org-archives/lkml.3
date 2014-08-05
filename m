Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaHESRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:17:32 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:42339 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755475AbaHESQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:16:06 -0400
X-IronPort-AV: E=Sophos;i="5.01,806,1400018400"; 
   d="scan'208";a="88390351"
Date: Tue, 5 Aug 2014 20:16:04 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Michal Marek <mmarek@suse.cz>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Coccinelle: Script to replace if and BUG with BUG_ON
In-Reply-To: <53E0E9D0.9040500@suse.cz>
Message-ID: <alpine.DEB.2.02.1408052015440.2047@localhost6.localdomain6>
References: <20140720213635.GA12365@himangi-Dell> <53E0E9D0.9040500@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Aug 2014, Michal Marek wrote:

> On 2014-07-20 23:36, Himangi Saraogi wrote:
> > This script detects cases where BUG() follows an if condition on an
> > expression and replaces the if condition and BUG() with a BUG_ON having
> > the conditional expression of the if statement as argument.
> > 
> > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> 
> Is this a result of some internal review, or where does Julia's Acked-by
> come from? I'm just wondering, because I haven't seen any previous
> version of this patch.

She sent it to me first.  It's OK with me.

julia
