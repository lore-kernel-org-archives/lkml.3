Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaKCJl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:41:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:50586 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaKCJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:41:55 -0500
Date: Mon, 3 Nov 2014 10:41:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
In-Reply-To: <1414908273-7552-16-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411031039470.5308@nanos>
References: <1414908273-7552-1-git-send-email-jiang.liu@linux.intel.com> <1414908273-7552-16-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2014, Jiang Liu wrote:
> +	down_write(&acpi_ioapic_rwsem);

That wants to be acpi_ioapic_lock. Same issue in the following
patches. You fixed it up in the last patch.

Please don't resend. I folded the hunks back to the proper places
already.

Thanks,

	tglx


