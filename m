Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3KBPJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:09:46 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:29382 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab3KBPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:09:44 -0400
X-IronPort-AV: E=Sophos;i="4.93,622,1378850400"; 
   d="scan'208";a="40387613"
Date: Sat, 2 Nov 2013 16:09:41 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Josh Triplett <josh@joshtriplett.org>
cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [PATCH] coccinelle: Add a script to find and remove unnecessary
 ifs with no body
In-Reply-To: <20131102150520.GV15704@leaf>
Message-ID: <alpine.DEB.2.02.1311021608550.2261@hadrien>
References: <20131102143236.GA18084@leaf> <alpine.DEB.2.02.1311021550330.2261@hadrien> <20131102150520.GV15704@leaf>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I observed several where the patch seemed entirely correct, with no
> FIXME/TODO/XXX comments associated with the conditional.
>
> Nonetheless, I don't mind removing the patch mode if you don't think
> it's worthwhile.  I'll send a v2.

I think it would be better without it.

thanks,
julia
