Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3GAFN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 01:13:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45592 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3GAFN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 01:13:27 -0400
Date: Mon, 1 Jul 2013 06:13:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matthew Thode <prometheanfire@gentoo.org>
Cc: Luca Barbato <lu_zero@gentoo.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed),
 when booting with mem=300M
Message-ID: <20130701051320.GA6840@srcf.ucam.org>
References: <51CC6CAE.6070401@gentoo.org>
 <51CC81A2.8040305@gentoo.org>
 <51D10603.1080403@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D10603.1080403@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 30, 2013 at 11:30:59PM -0500, Matthew Thode wrote:

> mjg59, is there anything I can do to help move this bug forward?  I've
> done all I can think of (even tried a serial expresscard slot for logging).

It does sound like a bug, but unfortunately unless it can be duplicated 
on real hardware without restrictive mem= arguments it's likely to be 
low on my priorities - there's still enough UEFI bugs that hit people in 
default configurations that they tend to get priority, I'm afraid.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
