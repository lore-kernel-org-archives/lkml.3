Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3CASWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:22:03 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37380 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3CASWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:22:01 -0500
Date: Fri, 1 Mar 2013 18:21:57 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: ownssh <ownssh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130301182157.GA1306@srcf.ucam.org>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <loom.20130227T103444-514@post.gmane.org>
 <20130227145647.GA5184@srcf.ucam.org>
 <loom.20130227T210924-53@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20130227T210924-53@post.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 08:35:45PM +0000, ownssh wrote:
> Matthew Garrett <mjg59 <at> srcf.ucam.org> writes:
> 
> > There's no way to update the UEFI key database without the update being 
> > signed by an already trusted key, so what you're proposing isn't 
> > possible.
> > 
> 
> I confused.
> Isn't custom mode can add user's own key?

Yes, but that involves physically-present end-user interaction. A 
bootloader can't do it even if it's signed by Microsoft.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
