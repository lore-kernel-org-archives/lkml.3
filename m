Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3JRGJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 02:09:35 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62105 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3JRGJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 02:09:33 -0400
Date: Fri, 18 Oct 2013 08:09:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH v10 00/12] rework arch/x86/platform/[mrst => intel-mid]
Message-ID: <20131018060929.GB3411@gmail.com>
References: <1382049336-21316-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382049336-21316-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Cohen <david.a.cohen@linux.intel.com> wrote:

> David Cohen (3):
>   intel-mid: sfi: allow struct devs_id.get_platform_data to be NULL
>   x86: intel-mid: add section for sfi device table
>   intel_mid: move board related codes to their own platform_<device>.*
>     files
> 
> Fengguang Wu (1):
>   pci: intel_mid: return true/false in function returning bool
> 
> Kuppuswamy Sathyanarayanan (8):
>   mrst: Fixed printk/pr_* related issues
>   mrst: Fixed indentation issues
>   intel_mid: Renamed *mrst* to *intel_mid*
>   intel_mid: Renamed *mrst* to *intel_mid*
>   intel_mid: Refactored sfi_parse_devs() function
>   intel_mid: Added custom device_handler support
>   intel_mid: Added custom handler for ipc devices
>   intel_mid: Moved SFI related code to sfi.c

Btw., when submitting a series _please_ harmonize the patch titles.

1)

Verbs should be present tense, i.e.:

->   intel_mid: Renamed *mrst* to *intel_mid*
->   intel_mid: Renamed *mrst* to *intel_mid*
+>   intel_mid: Rename *mrst* to *intel_mid*
+>   intel_mid: Rename *mrst* to *intel_mid*

2)

Use consistent capitalization:

->   pci: intel_mid: return true/false in function returning bool
+>   pci: intel_mid: Return true/false in function returning bool

3)

Use standard, consistent subsystem prefixes:

->   x86: intel-mid: add section for sfi device table
->   intel_mid: Renamed *mrst* to *intel_mid*
+>    x86/intel-mid: Add section for sfi device table
+>    x86/intel/mid: Rename *mrst* to *intel_mid*

etc.

Thanks,

	Ingo
