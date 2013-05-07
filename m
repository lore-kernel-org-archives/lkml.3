Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab3EGUtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:49:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57775 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab3EGUtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:49:00 -0400
Date: Tue, 7 May 2013 22:49:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Lance Ortiz <lance.ortiz@hp.com>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: WARNING at drivers/pci/search.c:214 for 3.9
Message-ID: <20130507204958.GF7633@pd.tnic>
References: <20130506162112.6b79b7b1@pluto.restena.lu>
 <20130506150757.GC22041@pd.tnic>
 <20130507085205.5a41b5ca@pluto.restena.lu>
 <20130507103830.GA7633@pd.tnic>
 <20130507153349.4d03040a@pluto.restena.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130507153349.4d03040a@pluto.restena.lu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 03:33:49PM +0200, Bruno Prémont wrote:
> With the BIOS updated, the error message is gone (both the Hardware
> error, and the WARNINGs triggered by attempting to lookup the source
> PCIe device) Not sure which of the two public updates did the fix...

Yeah, who knows. At least it got fixed.

> > I don't understand: are you saying this patch breaks detection of your
> > keyboard and touchpad and if you revert it, it works again? But 3.9 works?
> 
> No, that was the commit message of the SUSE guy who performed
> the revert for SUSE kernel!

Oh ok, I see. SP2 was probably missing some other commits from upstream.
Ok, good, so it was a BIOS issue and it got fixed by a BIOS update.
Seldom do I see bugs resolved that way :-).

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
