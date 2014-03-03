Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaCCAIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:08:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43553 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbaCCAII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:08:08 -0500
Date: Mon, 3 Mar 2014 00:07:59 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140303000759.GA25085@srcf.ucam.org>
References: <53129256.6060704@zytor.com>
 <20140302022334.GA1131@srcf.ucam.org>
 <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com>
 <53130A46.1010801@linux.intel.com>
 <cfbdc582-9fc0-4335-9974-d508c2da1c71@email.android.com>
 <5313AD1B.6050403@linux.intel.com>
 <20140302222654.GA17838@srcf.ucam.org>
 <5313B47B.6020402@linux.intel.com>
 <20140302231154.GA20891@srcf.ucam.org>
 <5313BD5A.1040409@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5313BD5A.1040409@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 07:23:06AM +0800, Li, Aubrey wrote:

> Windows doesn't do because there is no 32/64 mixed windows and EFI on
> the planet. Since the silicon is actually 64 bit, I failed to see a
> reason to refuse the user install 64bit linux on it. So we encountered a
> case windows didn't.

And we'll call the 32 bit EFI call, so what's the problem?

> So, you didn't mention BOOT_BIOS, if you don't want to add BOOT_BIOS,
> and you also don't like DMI entires, how do you want to deal with the
> machines requiring BOOT_BIOS to reboot their machine?

I was planning on ignoring them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
