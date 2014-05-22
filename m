Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaEVPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:25:29 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37720 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEVPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:25:26 -0400
Date: Thu, 22 May 2014 17:25:10 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: remove checks for CONFIG_SGI_IP35
Message-ID: <20140522152510.GD17197@linux-mips.org>
References: <1400584909.4912.35.camel@x220>
 <20140522131243.GZ10287@linux-mips.org>
 <1400767088.16407.14.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400767088.16407.14.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 03:58:08PM +0200, Paul Bolle wrote:

> By the way, could you perhaps look at CONFIG_SYS_HAS_CPU_RM9000? It
> seems the Kconfig entry for SYS_HAS_CPU_RM9000 is simply missing. But
> the CPU support code is rather complicated and I stopped trying to
> understand it after staring at it for way too long.

Seem that crept back in through commit 69f24d17 [MIPS: Optimize
current_cpu_type() for better code.] which had been developed before
but merged after RM9000 was removed.

There were various other artifacts of the RM9000 support around which I
also removed.  Only a few comments and PRID_IMP_RM9000 which helps
avoid accidental reuse of the value are now remaining.

  Ralf
