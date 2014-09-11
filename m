Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaIKO32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:29:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:15446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaIKO30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:29:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,506,1406617200"; 
   d="scan'208";a="601478355"
Message-ID: <5411B1BE.8010106@linux.intel.com>
Date: Thu, 11 Sep 2014 22:29:18 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Ni, Xun" <xun.ni@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC Part2 v1 15/21] x86, MSI: Use hierarchy irqdomain to manage
 MSI interrupts
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com> <1410444228-3134-16-git-send-email-jiang.liu@linux.intel.com> <91E2D863603AD4478F101CE81E76E45D01B8E653@SHSMSX103.ccr.corp.intel.com>
In-Reply-To: <91E2D863603AD4478F101CE81E76E45D01B8E653@SHSMSX103.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/11 22:17, Ni, Xun wrote:
> It has mis-understandings in your word" helps to make the and and architecture" ...
Hi Xun,
	Thanks, will fix it in next version.
Regards!
Gerry
> 
> Thanks
> Xun
> 
