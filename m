Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab3CTTNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:13:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41992 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab3CTTNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:13:34 -0400
Date: Wed, 20 Mar 2013 19:12:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Michal Marek <mmarek@suse.cz>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp: Add pciehp_surprise module option
Message-ID: <20130320191250.GA11262@srcf.ucam.org>
References: <s5h38vqjhk6.wl%tiwai@suse.de>
 <20130320175234.GA8948@srcf.ucam.org>
 <s5hppytq430.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hppytq430.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 08:11:15PM +0100, Takashi Iwai wrote:
> At Wed, 20 Mar 2013 17:52:34 +0000,
> Matthew Garrett wrote:
> > Well that just sounds like a bug. What's the downside to just ignoring 
> > that capability bit?
> 
> I'm afraid that it's too radical to enable always.

Why?

> Or, what about to check this bit only for disable path?

What happens if you unplug the device on one of the affected machines?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
