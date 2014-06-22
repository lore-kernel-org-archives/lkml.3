Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaFVImk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:42:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42753 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaFVImf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:42:35 -0400
Date: Sun, 22 Jun 2014 10:42:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V4 00/42] use irqdomain to dynamically allocate IRQ for
 IOAPIC
Message-ID: <20140622084227.GA13974@gmail.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


JFYI, with these patches applied x86 allyes32config fails with:

  arch/x86/platform/intel-mid/device_libs/platform_wdt.c:45:3: error: implicit declaration of function ‘io_apic_set_pci_routing’ 

Thanks,

	Ingo
