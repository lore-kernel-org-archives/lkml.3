Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3F0RnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:43:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34719 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3F0RnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:43:08 -0400
Date: Thu, 27 Jun 2013 18:43:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matthew Thode <prometheanfire@gentoo.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        kernel@gentoo.org, hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed),
 when booting with mem=300M
Message-ID: <20130627174305.GA16661@srcf.ucam.org>
References: <51CC6CAE.6070401@gentoo.org>
 <20130627172705.GA16316@srcf.ucam.org>
 <51CC78C2.2020406@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CC78C2.2020406@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:39:14PM -0500, Matthew Thode wrote:
> On 06/27/2013 12:27 PM, Matthew Garrett wrote:
> > On Thu, Jun 27, 2013 at 11:47:42AM -0500, Matthew Thode wrote:
> >> There is an early boot failure with linux-3.[9,10].??? when booting
> >> using uefi on low memory systems.
> > 
> > Does it happen on systems that genuinely have small amounts of memory, 
> > or only on systems where you're passing mem=?
> > 
> I don't have a system (or even memory to place in this one) that has
> that small amount of memory.  Do they even make ddr3 sodimms that small?

I've no idea. If a bug can't be triggered on any hardware that actually 
exists, it doesn't seem like a high priority.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
