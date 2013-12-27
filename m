Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3L0U0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:26:18 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:54335
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754737Ab3L0U0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:26:17 -0500
X-IronPort-AV: E=Sophos;i="4.95,562,1384297200"; 
   d="scan'208";a="42486408"
Date: Fri, 27 Dec 2013 21:26:14 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Alessandro Zummo <a.zummo@towertech.it>
cc: Julia Lawall <julia.lawall@lip6.fr>, grant.likely@linaro.org,
        robh+dt@kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: question about drivers/rtc/rtc-cmos.c
In-Reply-To: <20131227182942.66e7b109@linux.lan.towertech.it>
Message-ID: <alpine.DEB.2.02.1312272124180.2018@localhost6.localdomain6>
References: <alpine.DEB.2.02.1312252028170.2020@localhost6.localdomain6> <20131227182942.66e7b109@linux.lan.towertech.it>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Dec 2013, Alessandro Zummo wrote:

> On Wed, 25 Dec 2013 20:32:12 +0100 (CET)
> Julia Lawall <julia.lawall@lip6.fr> wrote:
> 
> 
> > Is it intentional that the error code returned by 
> > hpet_register_irq_handler is put ina local variable that will not be seen 
> > at label cleanup1?  The return value is retval, which is 0 at this point.
> 
>   Well, I'd say it's an error. Did you got it by hand
>   or with one of your tools? ;)

Coccinelle.  No idea if it an happen in real life.

I will drop err and replace it by retval.

julia
