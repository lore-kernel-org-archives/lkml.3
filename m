Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3JJR6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:58:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57292 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab3JJR6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:58:42 -0400
Date: Thu, 10 Oct 2013 18:58:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Jones <pjones@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131010175828.GA9065@srcf.ucam.org>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
 <20131010173710.GA18821@fenchurch.internal.datastacks.com>
 <20131010174521.GA27218@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010174521.GA27218@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 07:45:21PM +0200, Ingo Molnar wrote:

> Also, the main question would be, what is the typical value for 
> si->lfb_depth. 32 on almost all EFI systems? All around the map? Depends 
> on what graphics state the EFI bootloader passes us?

Microsoft require that it be 32, so in practice I suspect it'll always 
be 32. It's possible that Itanium decides to be different.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
