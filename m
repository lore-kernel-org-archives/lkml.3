Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaEVNSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:18:48 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37160 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbaEVNSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:18:45 -0400
Date: Thu, 22 May 2014 15:18:36 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: PNX833x: remove checks for CONFIG_I2C_PNX0105
Message-ID: <20140522131836.GB10287@linux-mips.org>
References: <1400586123.4912.40.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400586123.4912.40.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 01:42:03PM +0200, Paul Bolle wrote:

> 
> Checks for CONFIG_I2C_PNX0105 were added in v2.6.28. But the related
> Kconfig symbol has not been added to the tree. Remove these checks.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
> Note that there's no i2c-pnx0105.h in the tree.

And if I was holding my breath waiting for it to be comitted I'd already
be dead and rotten.  Queued for 3.16.

  Thanks,

  Ralf
