Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935606AbaFJAe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:34:27 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:47666 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934480AbaFJAWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:42 -0400
Date: Mon, 9 Jun 2014 17:22:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Patch V4 01/42] x86, irq: update high address field when updating
 affinity for MSI IRQ
In-Reply-To: <1402302011-23642-2-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1406091722260.17705@chino.kir.corp.google.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com> <1402302011-23642-2-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Jiang Liu wrote:

> If x2apic is enabled, the MSI high address field should also be aslo
> updated when setting affinity for MSI IRQ, otherwise the MSI IRQ may
> target wrong APIC IDs.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: stable@vger.kernel.org

Acked-by: David Rientjes <rientjes@google.com>
