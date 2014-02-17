Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaBQKz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:55:26 -0500
Received: from top.free-electrons.com ([176.31.233.9]:38264 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbaBQKzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:55:25 -0500
Date: Mon, 17 Feb 2014 11:54:39 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: at91: Add at91sam9rl DT SoC support
Message-ID: <20140217105439.GC21303@piout.net>
References: <1392426860-19589-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1392426860-19589-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20140217112013.723a4e12@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217112013.723a4e12@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/2014 at 11:20:13 +0100, Thomas Petazzoni wrote :
> Dear Alexandre Belloni,
> 
> On Sat, 15 Feb 2014 02:14:18 +0100, Alexandre Belloni wrote:
> 
> > +	model = "Atmel AT91SAM9RL family SoC";
> > +	compatible = "atmel,at91sam9rl";
> 
> Since you have it in your board .dts file, I guess you should add the
> atmel,at91sam9 compatible string here:
> 
> 	compatible = "atmel,at91sam9rl", "atmel,at91sam9";


I agree that it would be better but that is not done on other at91sam9
socs. Nicolas, can you comment ?

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
