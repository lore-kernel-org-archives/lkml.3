Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbbAVKjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:39:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:59011 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbbAVKjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:39:02 -0500
Date: Thu, 22 Jan 2015 11:38:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Zheng, Lv" <lv.zheng@intel.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [RFC Patch 05/19] ACPI: Provide union for address_space64 and
 ext_address_space64
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026B9F36@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.11.1501221134370.5526@nanos>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-6-git-send-email-jiang.liu@linux.intel.com> <1AE640813FDE7649BE1B193DEA596E88026B9EFB@SHSMSX101.ccr.corp.intel.com> <54C06726.4090805@linux.intel.com>
 <1AE640813FDE7649BE1B193DEA596E88026B9F36@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Zheng, Lv wrote:
> If we can reach an agreement on the linuxized version, then it can
> be merged directly by Rafael.  And I'll zap it from the ACPICA
> release series.

Fine with me.

Thanks,

	tglx

