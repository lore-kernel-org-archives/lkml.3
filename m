Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaB1GkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:40:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:2707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaB1GkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:40:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,560,1389772800"; 
   d="scan'208";a="483355663"
Message-ID: <53102F3C.4020806@linux.intel.com>
Date: Fri, 28 Feb 2014 14:39:56 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len.Brown@intel.com, Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53100C8D.1060001@linux.intel.com> <20140228045637.GA28257@srcf.ucam.org> <53101D1D.9010202@linux.intel.com> <20140228055629.GA847@srcf.ucam.org> <531027BE.2010807@linux.intel.com> <20140228061254.GA2226@srcf.ucam.org> <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org>
In-Reply-To: <20140228062325.GA3246@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/28 14:23, Matthew Garrett wrote:
> On Fri, Feb 28, 2014 at 02:20:41PM +0800, Li, Aubrey wrote:
> 
>> Well, I already figured that out. Reset Register Supported flag is ZERO
>> in FACP table. I attached this table for your interesting.
> 
> Ok, in that case we need to check how Windows deals with a FACP that has 
> this flag set to 0 but valid looking registers defined. I'll see if I 
> can do that tomorrow.
> 

Just let you know, Windows8.1 calls EFI on these boxes for reboot/shutdown.

I'll be surprise if other windows version ignores RESET_REG_SUP to use
ACPI reset registers.

=========ACPI spec ==============================
RESET_REG_SUP: If set, indicates the system supports system reset via
the FADT RESET_REG as described in Section 4.8.3.6
=================================================

Thanks for checking that, please keep me posted. I'll re-submit the
patch after you have an update.

-Aubrey
