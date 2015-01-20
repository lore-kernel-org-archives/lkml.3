Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbbATJ4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:56:37 -0500
Received: from smtp.citrix.com ([66.165.176.89]:48184 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbbATJ4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:56:35 -0500
X-IronPort-AV: E=Sophos;i="5.09,433,1418083200"; 
   d="scan'208";a="218898550"
Message-ID: <54BE2649.8010504@citrix.com>
Date: Tue, 20 Jan 2015 09:56:25 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Lv Zheng <lv.zheng@intel.com>
CC: Tony Luck <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Bugfix 3/3] xen/irq: Override ACPI IRQ management callback __acpi_unregister_gsi
References: <1421720467-7709-1-git-send-email-jiang.liu@linux.intel.com> <1421720467-7709-4-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1421720467-7709-4-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/15 02:21, Jiang Liu wrote:
> Xen overrides __acpi_register_gsi and leaves __acpi_unregister_gsi as is.
> That means, an IRQ allocated by acpi_register_gsi_xen_hvm() or
> acpi_register_gsi_xen() will be freed by acpi_unregister_gsi_ioapic(),
> which may cause undesired effects. So override __acpi_unregister_gsi to
> NULL for safety.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thanks.

David
