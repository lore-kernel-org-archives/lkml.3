Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3KBQtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 12:49:33 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:1812 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962Ab3KBQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 12:49:31 -0400
X-IronPort-AV: E=Sophos;i="4.93,622,1378850400"; 
   d="scan'208";a="40399527"
Date: Sat, 2 Nov 2013 17:49:27 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Josh Triplett <josh@joshtriplett.org>
cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [PATCHv2] coccinelle: Add a script to find unnecessary ifs with
 no body
In-Reply-To: <20131102151500.GW15704@leaf>
Message-ID: <alpine.DEB.2.02.1311021748590.2261@hadrien>
References: <20131102143236.GA18084@leaf> <alpine.DEB.2.02.1311021550330.2261@hadrien> <20131102151500.GW15704@leaf>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +@r depends on report || context@
> +expression E;
> +position p;
> +@@
> +if@p (E) {}

There should be a * in front of the if, to support context mode.

julia
