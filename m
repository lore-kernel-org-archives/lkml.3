Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3KGFNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:13:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3KGFNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:13:50 -0500
Date: Wed, 6 Nov 2013 22:26:44 +0100
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joe Perches <joe@perches.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Mario <jmario@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] kbuild: Increase kallsyms max symbol length v2
Message-ID: <20131106212644.GB22142@pobox.suse.cz>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org> <1382456783-22826-2-git-send-email-andi@firstfloor.org> <1382459764.2041.90.camel@joe-AO722> <20131023130653.GN29695@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023130653.GN29695@two.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 03:06:53PM +0200, Andi Kleen wrote:
> From: Joe Mario <jmario@redhat.com>
> 
> [AK: This seems like a ticking time bomb even without LTO,
> so should be merged now. It causes very weird problems.
> Thanks to Joe for tracking them down.]
> 
> With the added postfixes that LTO adds for local
> symbols, the longest name in the kernel overflows
> the namebuf[KSYM_NAME_LEN] array by two bytes.  That name is:
> __pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt.1488004.672802
> 
> Double the max symbol name length.
> 
> v2: Use 255  (Joe Perches)
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Applied to kbuild.git#kbuild.

Michal
