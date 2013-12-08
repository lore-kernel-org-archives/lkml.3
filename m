Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3LHQOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 11:14:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38542 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab3LHQOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 11:14:02 -0500
Date: Sun, 8 Dec 2013 17:13:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Lance Ortiz <lance.ortiz@hp.com>,
        Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI, AER: Add a TLP header print helper
Message-ID: <20131208161357.GF4338@pd.tnic>
References: <1386515571-23252-1-git-send-email-bp@alien8.de>
 <1386518724.31845.66.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386518724.31845.66.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 08:05:24AM -0800, Joe Perches wrote:
> On Sun, 2013-12-08 at 16:12 +0100, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > ... and call it instead of duplicating the large printk format
> > statement.
> > 
> > No functionality change.
> 
> You do change the output.

That's ok. "TLP Header:" is the proper way to print it anyway.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
