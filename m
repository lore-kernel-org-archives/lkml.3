Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab3BMKy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:54:26 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:48359 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab3BMKyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:54:25 -0500
Date: Wed, 13 Feb 2013 19:54:22 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, johnstul@us.ibm.com,
        shinya.kuribayashi.px@renesas.com, tglx@linutronix.de
Subject: Re: [PATCH 00/08] clocksource: sh_cmt: CMT driver update
Message-ID: <20130213105422.GA22623@verge.net.au>
References: <20121214055323.10081.12056.sendpatchset@w520>
 <Pine.LNX.4.64.1302130927280.18535@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1302130927280.18535@axis700.grange>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:45:13AM +0100, Guennadi Liakhovetski wrote:
> Hi Magnus
> 
> On Fri, 14 Dec 2012, Magnus Damm wrote:
> 
> > clocksource: sh_cmt: CMT driver update
> > 
> > [PATCH 01/08] clocksource: sh_cmt: Take care of clk_put() when setup_irq() fails
> > [PATCH 02/08] clocksource: sh_cmt: Initialize 'max_match_value' and 'lock' in sh_cmt_setup()
> > [PATCH 03/08] clocksource: sh_cmt: Consolidate platform_set_drvdata() call
> > [PATCH 04/08] clocksource: sh_cmt: Introduce per-register functions
> > [PATCH 05/08] clocksource: sh_cmt: CMSTR and CMCSR register access update
> > [PATCH 06/08] clocksource: sh_cmt: CMCNT and CMCOR register access update
> > [PATCH 07/08] clocksource: sh_cmt: Add control register callbacks
> > [PATCH 08/08] clocksource: sh_cmt: Add CMT register layout comment
> 
> On a kzm9g board with -reference DT configuration and on armadillo800eva:
> 
> Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks, I have applied these to the clocksource branch.
