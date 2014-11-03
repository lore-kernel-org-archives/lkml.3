Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaKCJvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:51:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:17730 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaKCJvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:51:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="484025385"
Message-ID: <54575008.50307@linux.intel.com>
Date: Mon, 03 Nov 2014 17:51:04 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, x86@kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch v8 15/18] x86, irq, ACPI: Implement interface to support
 ACPI based IOAPIC hot-addition
References: <1414908273-7552-1-git-send-email-jiang.liu@linux.intel.com> <1414908273-7552-16-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1411031039470.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1411031039470.5308@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/3 17:41, Thomas Gleixner wrote:
> On Sun, 2 Nov 2014, Jiang Liu wrote:
>> +	down_write(&acpi_ioapic_rwsem);
> 
> That wants to be acpi_ioapic_lock. Same issue in the following
> patches. You fixed it up in the last patch.
> 
> Please don't resend. I folded the hunks back to the proper places
> already.
Thanks, Thomas.

There's no changes for the second patch set "[Patch Part1 v3 00/20]
Prepare for enabling  hierarchy irqdomain on x86" at
https://lkml.org/lkml/2014/10/27/122.

It should apply cleanly onto this patch set, so I won't resend it.

I have also solved all issues related to interrupt remapping and
is testing new implementation for third and fourth patch sets.
Will send them out once passing all tests.

Regards!
Gerry

> 
> Thanks,
> 
> 	tglx
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
