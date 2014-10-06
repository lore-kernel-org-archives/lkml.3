Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaJFTqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:46:00 -0400
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:53906 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbaJFTp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:45:58 -0400
Date: Mon, 6 Oct 2014 14:45:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Lang <david@lang.hm>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <alpine.DEB.2.02.1410060830100.26324@nftneq.ynat.uz>
Message-ID: <alpine.DEB.2.11.1410061445170.31391@gentwo.org>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain> <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
 <alpine.DEB.2.11.1410052331420.4383@nanos> <alpine.DEB.2.11.1410051824190.3424@gentwo.org> <alpine.DEB.2.11.1410060959510.4383@nanos> <alpine.DEB.2.11.1410060521010.27574@gentwo.org> <alpine.DEB.2.11.1410061449290.4383@nanos> <alpine.DEB.2.11.1410061014080.29937@gentwo.org>
 <alpine.DEB.2.02.1410060830100.26324@nftneq.ynat.uz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014, David Lang wrote:

> No, tools recognize that things happen (wraps, reboots, etc) and have some
> threshold that they say "if this value changes more than the threshold,
> something happened and it's not valid to use this delta"
>
> This has been the case for decades. If you have a monitoring tool that does
> not account for this sort of thing, you have an immature tool.

Well maybe put those statement somewhere to find for those writing
diagnostics tools that use the counters.

