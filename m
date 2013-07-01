Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3GAGZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 02:25:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46037 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab3GAGZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:25:34 -0400
Date: Mon, 1 Jul 2013 07:25:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Luca Barbato <lu_zero@gentoo.org>
Cc: Matthew Thode <prometheanfire@gentoo.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed),
 when booting with mem=300M
Message-ID: <20130701062530.GA7423@srcf.ucam.org>
References: <51CC6CAE.6070401@gentoo.org>
 <51CC81A2.8040305@gentoo.org>
 <51D10603.1080403@gentoo.org>
 <20130701051320.GA6840@srcf.ucam.org>
 <51D11218.5040601@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D11218.5040601@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 07:22:32AM +0200, Luca Barbato wrote:

> MacBookPro8,2 with efi-stub, loading directly from the efi shell w/out
> any memory restriction.

How do you know this is the same issue?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
