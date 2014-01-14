Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaANQmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:42:36 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60791 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbaANQm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:42:29 -0500
Date: Tue, 14 Jan 2014 16:42:27 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Takashi Iwai <tiwai@suse.de>, Len Brown <lenb@kernel.org>,
        Oliver Neukum <oneukum@suse.de>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ACPI: Blacklist Win8 OSI for some HP laptop
 2013 models
Message-ID: <20140114164227.GA7752@srcf.ucam.org>
References: <1389611658-19424-1-git-send-email-tiwai@suse.de>
 <6355285.UpbP9PuN7a@vostro.rjw.lan>
 <20140114163425.GA6649@srcf.ucam.org>
 <4325437.Itfr0xDDg7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4325437.Itfr0xDDg7@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 05:53:20PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, January 14, 2014 04:34:25 PM Matthew Garrett wrote:
> > rfkill and backlight control presumably work fine under Windows 8, so 
> > there's obviously some new mechanism for doing so. HP will presumably 
> > ship more hardware that behaves this way, so if we don't add support for 
> > the new mechanisms then we'll just have to keep adding entries to the 
> > blacklist.
> 
> Well, presumably.
> 
> To add any kind of support for anything we need to know how that thing
> works in the first place which we don't in this particular case, at least
> at the moment.  I hontestly don't want the users of those systems to wait
> until we figure that out.

Adding blacklist entries without making some effort to figure out what 
the underlying problem is doesn't provide any incentive for fixing the 
underlying problem. In this case Toshio has described what the problem 
is and it sounds like fixing the rfkill problem is straightforward, so 
we should just classify this in the same way as all the other backlight 
control issues. Perhaps we should add it to the native video blacklist 
rather than the OSI one?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
