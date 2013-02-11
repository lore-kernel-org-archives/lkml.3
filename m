Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3BKJeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:34:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43328 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3BKJeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:34:22 -0500
Date: Mon, 11 Feb 2013 10:34:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/26] x86, irq: support ioapic device hotplug
Message-ID: <20130211093417.GC23932@gmail.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Hi,
> 
> Current x86 code does not support iapic hotplug yet.

Please give a better high-level description: outline how an 
IO-APIC will be hotplugged physically and what changes the 
user will experience.

That needs at least 2 paragraphs, not one cursory sentence. Then 
should come technical descriptions - but even those need 
improvements, please first explain the current status quo, then 
explain how that is inadequate for IO-APIC hot-plugging, *then* 
only explain what you are doing in the patch ...

Thanks,

	Ingo
