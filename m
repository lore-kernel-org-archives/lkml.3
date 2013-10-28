Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3J1UfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 16:35:20 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45344 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755323Ab3J1UfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 16:35:19 -0400
Date: Mon, 28 Oct 2013 20:35:15 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Christoph Hellwig <hch@infradead.org>,
        Chen Gong <gong.chen@linux.intel.com>, X86-ML <x86@kernel.org>
Subject: Re: [PATCH] Move cper.c from drivers/acpi/apei to
 drivers/firmware/efi
Message-ID: <20131028203515.GP1982@console-pimps.org>
References: <20131027204648.GG1982@console-pimps.org>
 <526eb2c117027ea234@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526eb2c117027ea234@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct, at 11:53:53AM, Luck, Tony wrote:
> cper.c contains code to decode and print "Common Platform Error Records".
> Originally added under drivers/acpi/apei because the only user was in that
> same directory - but now we have another consumer, and we shouldn't have
> to force CONFIG_ACPI_APEI get access to this code.
> 
> Since CPER is defined in the UEFI specification - the logical home for
> this code is under drivers/firmware/efi/
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ---
> 
> Matt: as discussed earlier on the mailing list ... just looking
> for your "Acked-by" so this can go on top of the patch series in
> the x86/mce branch of the tip tree that already makes a bunch of
> changes to cper.c

You got it.

Acked-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
