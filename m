Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaFWOMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:12:47 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:27902
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbaFWOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:12:45 -0400
X-IronPort-AV: E=Sophos;i="5.01,530,1400018400"; 
   d="scan'208";a="68488535"
Date: Mon, 23 Jun 2014 16:12:41 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/10] video: use safer test on the result of
 find_first_zero_bit
In-Reply-To: <53A81470.5030606@ti.com>
Message-ID: <alpine.DEB.2.10.1406231612030.3905@hadrien>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr> <1401872880-23685-4-git-send-email-Julia.Lawall@lip6.fr> <53A81470.5030606@ti.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014, Tomi Valkeinen wrote:

> On 04/06/14 12:07, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
> > return a larger number than the maximum position argument if that position
> > is not a multiple of BITS_PER_LONG.
>
> Thanks, queued for 3.17.

No, sorry you can drop it.  It doesn't hurt anything, but it is not
necessary either.  Returning a larger number is actually not possible.

julia
