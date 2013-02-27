Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174Ab3B0O4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:56:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48566 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791Ab3B0O4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:56:50 -0500
Date: Wed, 27 Feb 2013 14:56:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: ownssh <ownssh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130227145647.GA5184@srcf.ucam.org>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <loom.20130227T103444-514@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20130227T103444-514@post.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 09:35:24AM +0000, ownssh wrote:

> I think, redhat should have their own root key to sign binary files.
> Bootloader of install media can be sign by MS certificates, but only use to add
> the redhat root key to UEFI database before install.

There's no way to update the UEFI key database without the update being 
signed by an already trusted key, so what you're proposing isn't 
possible.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
