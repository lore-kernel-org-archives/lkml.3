Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3F0R1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:27:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34518 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3F0R1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:27:09 -0400
Date: Thu, 27 Jun 2013 18:27:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matthew Thode <prometheanfire@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-devel@vger.kernel.org,
        torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed),
 when booting with mem=300M
Message-ID: <20130627172705.GA16316@srcf.ucam.org>
References: <51CC6CAE.6070401@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CC6CAE.6070401@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 11:47:42AM -0500, Matthew Thode wrote:
> There is an early boot failure with linux-3.[9,10].??? when booting
> using uefi on low memory systems.

Does it happen on systems that genuinely have small amounts of memory, 
or only on systems where you're passing mem=?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
