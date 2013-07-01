Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3GAWqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:46:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36322 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab3GAWqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:46:03 -0400
Date: Tue, 2 Jul 2013 00:45:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v3 1/3] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
Message-ID: <20130701224555.GM23515@pd.tnic>
References: <20130701153728.6197.14022.stgit@localhost.localdomain>
 <20130701153847.6197.88582.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130701153847.6197.88582.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 09:08:47PM +0530, Naveen N. Rao wrote:
> The Corrected Machine Check structure (CMC) in HEST has a flag which can be
> set by the firmware to indicate to the OS that it prefers to process the
> corrected error events first. In this scenario, the OS is expected to not
> monitor for corrected errors (through CMCI/polling). Instead, the firmware
> notifies the OS on corrected error events through GHES.
> 
> Linux already has support for GHES. This patch adds support for parsing CMC
> structure and to disable CMCI/polling if the firmware first flag is set.
> 
> Further, the list of machine check bank structures at the end of CMC is used
> to determine which MCA banks function in FF mode, so that we continue to
> monitor error events on the other banks.
> 
> 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
