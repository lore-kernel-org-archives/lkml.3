Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaIVG5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 02:57:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46207 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751128AbaIVG5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 02:57:48 -0400
Date: Mon, 22 Sep 2014 08:57:45 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH 1/2] bus: brcmstb_gisb: register the fault code hook
Message-ID: <20140922085745.1c515be8@free-electrons.com>
In-Reply-To: <20140921231010.GN7362@norris-Latitude-E6410>
References: <1411155880-23447-1-git-send-email-f.fainelli@gmail.com>
	<1411155880-23447-2-git-send-email-f.fainelli@gmail.com>
	<20140920151950.443b7ea9@free-electrons.com>
	<20140921231010.GN7362@norris-Latitude-E6410>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian,

On Sun, 21 Sep 2014 16:10:10 -0700, Brian Norris wrote:

> > I don't have the entire context, but if your platform is part of
> > multi-platform, it means that regardless of which platform is actually
> > booting your system, you will register your fault hook. Is this the
> > intended behavior?
> > 
> > Generally speaking, in a multiplatform context, many arch_initcall()
> > should have a conditional to check whether we're really on a platform
> > where the initcall is needed.
> 
> Florian already sent v2, about which I already made a similar comment:
> 
>   https://lkml.org/lkml/2014/9/19/516

Yes, sorry. I saw your review after I sent my e-mail :)

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
