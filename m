Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3GAUx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:53:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33858 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3GAUx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:53:56 -0400
Date: Mon, 1 Jul 2013 22:53:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] N900: fix operation on emulator
Message-ID: <20130701205353.GB22174@amd.pavel.ucw.cz>
References: <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
 <20130613161418.GJ8164@atomide.com>
 <20130613230808.GA14876@amd.pavel.ucw.cz>
 <20130614055629.GM8164@atomide.com>
 <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
 <20130617111031.GQ20992@atomide.com>
 <20130701140315.GA15318@amd.pavel.ucw.cz>
 <51D1C8DD.6040409@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51D1C8DD.6040409@cogentembedded.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Errata workarounds for N900 hardware actually break operation on
> >emulator. Fix it.
> 
> >This approach was suggested by Pali Rohár <pali.rohar@gmail.com>
> >(thanks!).
> 
> >(Also explain what "sleep_ind" led actually does).
> 
>    Looks like unrelated change and probably worth another patch?

Ok, more serious issue is that code this was modifying is not yet in
mainline. Sorry.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
