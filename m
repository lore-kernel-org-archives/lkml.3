Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaEVNMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:12:49 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37160 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaEVNMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:12:48 -0400
Date: Thu, 22 May 2014 15:12:43 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: remove checks for CONFIG_SGI_IP35
Message-ID: <20140522131243.GZ10287@linux-mips.org>
References: <1400584909.4912.35.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400584909.4912.35.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 01:21:49PM +0200, Paul Bolle wrote:

> Ever since (shortly before) v2.4.0 there have been checks for
> CONFIG_SGI_IP35. But a Kconfig symbol SGI_IP35 was never added to the
> tree. Remove these checks.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
> For some reason CONFIG_SGI_IP35 was heavily used in arch/ia64 too.
> Anyhow, IA64 has dropped that macro years ago.

The #ifdefs exist because these headers are originally from IRIX and the
equivalent IRIX definitions were converted to Linux-style.  For the
IA64 version keeping those ifdefs around obviously made no sense since -
since IP35 (Origin 300/3000 series) is MIPS-based, so it was dropped
again.

There is some out-of-tree support for IP35 so I'd like to drop this
patch.

  Ralf
