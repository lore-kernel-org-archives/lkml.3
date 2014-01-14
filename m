Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaANQgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:36:07 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60545 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaANQgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:36:03 -0500
Date: Tue, 14 Jan 2014 16:36:00 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Oliver Neukum <oneukum@suse.de>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ACPI: Blacklist Win8 OSI for some HP laptop
 2013 models
Message-ID: <20140114163600.GB6649@srcf.ucam.org>
References: <1389611658-19424-1-git-send-email-tiwai@suse.de>
 <20140114161244.GD4307@srcf.ucam.org>
 <s5hvbxmtte9.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hvbxmtte9.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 05:33:50PM +0100, Takashi Iwai wrote:

> For the rfkill part, it depends on the user-space.  Without the patch,
> it sends a scan code, and OS is supposed to do rfkill via each
> driver.  The proper key mapping would be needed.  Not sure about the
> LED state on the WiFi button, though, whether it's properly controlled
> by WiFi and/or BT driver.  With the patch, all rfkill and LED are
> handled by BIOS, so it works as is.

Ok, so userspace needs to work - there's plenty of hardware that only 
sends a scancode already. Let's just add the keycode and then remove 
this once the backlight stuff is fixed.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
