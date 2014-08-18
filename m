Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaHRNVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:21:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55340 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaHRNVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:21:08 -0400
Message-ID: <1408368060.3398.1.camel@paszta.hi.pengutronix.de>
Subject: Re: altera reset controller in 3.16: failed with error -22
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Pavel Machek <pavel@denx.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, s.trumtrar@pengutronix.de,
        dinguyen@altera.com, Vince Bridgers <vbridgers2013@gmail.com>
Date: Mon, 18 Aug 2014 15:21:00 +0200
In-Reply-To: <20140818131623.GA21474@amd>
References: <20140818131623.GA21474@amd>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Am Montag, den 18.08.2014, 15:16 +0200 schrieb Pavel Machek:
> Hi!
> 
> I'm getting
> 
> socfpga-reset ffd05000.rstmgr: /soc/rstmgr@ffd05000 missing
> #reset-cells property
> socfpga-reset: probe of ffd05000.rstmgr failed with error -22
> 
> messages in 3.16... which is no wonder, since no socfpga-related dts
> contains that property. Is there part of the patch that is missing
> from 3.16?

yes, that would be dc8fbed5d9cc169ce0d50e2003416a43dda45ba6
"ARM: socfpga: Add missing #reset-cells to socfpga device tree"

regards
Philipp

