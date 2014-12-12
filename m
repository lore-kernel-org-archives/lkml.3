Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbaLLIYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:24:50 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:41490 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbaLLIYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:24:49 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412120847400.16494@nanos>
References: <20141211191853.613107396@linutronix.de>
	<20141211193112.813391696@linutronix.de>
	<CAE9FiQV4jArUDGuhb3o2BhiVGcGxSXhADU+5=NsdqJGQOo2oJQ@mail.gmail.com>
	<alpine.DEB.2.11.1412120847400.16494@nanos>
Date: Fri, 12 Dec 2014 00:24:48 -0800
X-Google-Sender-Auth: 5YKYla9NhOZY7wlauDrAsyXzrvY
Message-ID: <CAE9FiQVNc7s2aRsZmryqpOf07H8=6mS4GZHRUa6szHwdd-6mPw@mail.gmail.com>
Subject: Re: [patch 4/4] acpi: ioapic: Respect the resource flags
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> I still have no explanation why the translation offset needs to be
> applied here.

That should be copied from pci root bus resource setup.

But looks like only ia64 use those translation_offset?

Thanks

Yinghai
