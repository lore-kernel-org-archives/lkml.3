Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3J2IRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:17:07 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:65483 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3J2IRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:17:00 -0400
Date: Tue, 29 Oct 2013 09:16:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Christoph Hellwig <hch@infradead.org>,
        Chen Gong <gong.chen@linux.intel.com>, X86-ML <x86@kernel.org>
Subject: Re: [PATCH] Move cper.c from drivers/acpi/apei to
 drivers/firmware/efi
Message-ID: <20131029081656.GC16557@gmail.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> cper.c contains code to decode and print "Common Platform Error Records".
> Originally added under drivers/acpi/apei because the only user was in that
> same directory - but now we have another consumer, and we shouldn't have
> to force CONFIG_ACPI_APEI get access to this code.
> 
> Since CPER is defined in the UEFI specification - the logical home for
> this code is under drivers/firmware/efi/
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Looks good to me!

Acked-by: Ingo Molnar <mingo@kernel.org>

	Ingo
