Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaGGT4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:56:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60036 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbaGGT4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:56:00 -0400
Date: Mon, 7 Jul 2014 21:55:56 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/5] ARM: at91/dt: sama5d3: define mpddr clock and ramc
 clocks
Message-ID: <20140707195556.GI3113@piout.net>
References: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1404746355-19988-4-git-send-email-alexandre.belloni@free-electrons.com>
 <20140707183236.GF9558@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707183236.GF9558@ns203013.ovh.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 at 20:32:36 +0200, Jean-Christophe PLAGNIOL-VILLARD wrote :
> > -				compatible = "atmel,at91sam9g45-ddramc";
> > +				compatible = "atmel,sama5d3-mpddramc", "atmel,at91sam9g45-ddramc";
> the sama5 ddr controler is not back compitble with 9g45 one the compatible is
> wrong

Keeping atmel,at91sam9g45-ddramc allows to reuse the old code for the
iomap needed for the PM code without adding a new compatible in the
ramc_ids[] array.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
