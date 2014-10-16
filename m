Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaJPHRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:17:48 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53443 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaJPHRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:17:47 -0400
Date: Thu, 16 Oct 2014 09:17:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH 1/3] Numachip: fixes
Message-ID: <20141016071742.GA17555@gmail.com>
References: <1413377588-6985-1-git-send-email-daniel@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413377588-6985-1-git-send-email-daniel@numascale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel J Blueman <daniel@numascale.com> wrote:

> Fix APIC declaration to be consistent with definition; this 
> addresses a compilation failure with the development branch of 
> GCC, see: https://bugzilla.kernel.org/show_bug.cgi?id=78251
> 
> Fix 16-bit APIC ID truncation and redundant APIC ICR idle 
> polling for IPI to self (AMD64 APICs are documented in the 
> system developer manuals to queue APIC writes).
> 
> Finally, add safe function to check if Numachip is detected, to 
> be used elsewhere.

This should be 3 patches.

Thanks,

	Ingo
