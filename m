Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaIXT0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:26:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:57522 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaIXT0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:26:02 -0400
Date: Wed, 24 Sep 2014 21:25:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Part2 v1 00/21] Enable hierarchy irqdomian on x86
 platforms
In-Reply-To: <542279D0.1040603@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.10.1409242122380.4604@nanos>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com> <542279D0.1040603@jp.fujitsu.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Yasuaki Ishimatsu wrote:
> I cannot imagine why the feature makes x86 irq architecture much more clear
> and more easy to maintain in this description. Of course, I have read the
> following threads:
> 
> https://lkml.org/lkml/2014/9/11/101

Here is the long version of the idea:

     https://lkml.org/lkml/2014/8/26/707

Short version is:

Separate the irq handling entities in a clear layered way instead of
having vector/[io]apic specific knowledge/data in places like msi,
remap etc.

Thanks,

	tglx

