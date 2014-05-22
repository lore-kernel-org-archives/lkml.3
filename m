Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaEVNQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:16:07 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37160 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaEVNQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:16:05 -0400
Date: Thu, 22 May 2014 15:16:00 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: remove CONFIG_PMCTWILED completely
Message-ID: <20140522131600.GA10287@linux-mips.org>
References: <1400585676.4912.38.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400585676.4912.38.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 01:34:36PM +0200, Paul Bolle wrote:

> Commit 8b284dbc2200 ("MIPS: PNX Removing dead CONFIG_PMCTWILED") missed
> one reference to CONFIG_PMCTWILED in the code. It also missed one
> related reference to pmctwiled_setup(). Remove these references now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.

Who is testing MSP71xx anyway ...

Anyway, looks good.  Queued for 3.16.

  Ralf
