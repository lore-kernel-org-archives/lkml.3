Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaEVNFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:05:11 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37116 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaEVNFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:05:10 -0400
Date: Thu, 22 May 2014 15:04:59 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: remove check for
 CONFIG_CAVIUM_REPORT_SINGLE_BIT_ECC
Message-ID: <20140522130459.GY10287@linux-mips.org>
References: <1400583055.4912.28.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400583055.4912.28.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:50:55PM +0200, Paul Bolle wrote:

> A check for CONFIG_CAVIUM_REPORT_SINGLE_BIT_ECC was added in v2.6.29,
> but without the related Kconfig symbol. Remove this check.
> 
> Also remove the test for an "ecc_verbose" kernel parameter. It is
> undocumented and has no effect anyway.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
> Note that __cvmx_interrupt_ecc_report_single_bit_errors doesn't exist.

I tried to chase the history of this but as far as I was able to find,
this is unused since I initially merged Octeon support; beyond that
I wasn't able to find any history.

So queued for 3.16.

Thanks!

  Ralf
