Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaANQMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:12:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60082 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANQMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:12:48 -0500
Date: Tue, 14 Jan 2014 16:12:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Oliver Neukum <oneukum@suse.de>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ACPI: Blacklist Win8 OSI for some HP laptop
 2013 models
Message-ID: <20140114161244.GD4307@srcf.ucam.org>
References: <1389611658-19424-1-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389611658-19424-1-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 12:14:18PM +0100, Takashi Iwai wrote:
> The BIOS on recent HP laptops behaves differently with Win8 OSI,
> e.g. no backlight control and no rfkill are available.  List them in
> the blacklist as a workaround.

What's the plan for fixing this properly?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
