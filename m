Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbbA0XJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:09:48 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60904 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbA0XJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:09:46 -0500
Date: Wed, 28 Jan 2015 01:09:39 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
Message-ID: <20150127230938.GB591@fuloong-minipc.musicnaut.iki.fi>
References: <201501232239.55801@pali>
 <201501232336.36187@pali>
 <20150126161454.GE28663@atomide.com>
 <201501261723.10505@pali>
 <20150126170323.GF28663@atomide.com>
 <alpine.LFD.2.11.1501261318590.1322@knanqh.ubzr>
 <20150127133739.GB25306@amd>
 <alpine.LFD.2.11.1501271014160.1322@knanqh.ubzr>
 <20150127175359.GE11502@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271309450.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501271309450.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 01:50:22PM -0500, Nicolas Pitre wrote:
> Hence the ATAG-to-DT compat code in the decompressor.  This 
> was meant to smooth things around the transition to DT, etc.  After all, 
> those devices with non-replaceable bootloaders where shim layers are not 
> possible should get out of commission eventually?

Probably after 5 years there are still people using and hacking mainline
Linux with N900 etc., and newer OMAPs (since there no "useful" devices)
are long forgotten...

A.
