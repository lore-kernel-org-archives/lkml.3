Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3GAUIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:08:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41000 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab3GAUIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:08:38 -0400
Date: Mon, 1 Jul 2013 22:08:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v3 0/3] Firmware first mode for corrected errors
Message-ID: <20130701200830.GJ23515@pd.tnic>
References: <20130701153728.6197.14022.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130701153728.6197.14022.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 09:08:42PM +0530, Naveen N. Rao wrote:
> Hi Tony,
> Here is the updated patchset which addresses all previous review comments. For
> the third patch, I have also moved the soft-offline section in ghes.c into the
> #ifdef block for APEI_MEMORY_FAILURE.
> 
> If there are no further comments, can you please queue this up for 3.11?

I think you mean 3.12 - 3.11 merge window is open right now and patches
for it going in need to have spent some quality time in -next first.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
