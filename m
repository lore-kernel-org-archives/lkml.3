Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab3LJAka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:40:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36356 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab3LJAkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:40:22 -0500
Date: Tue, 10 Dec 2013 01:40:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rui Wang <ruiv.wang@gmail.com>, Lance Ortiz <lance.ortiz@hp.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        jiang.liu@intel.com, Tony Luck <tony.luck@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <rui.y.wang@intel.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] aerdrv: Fix severity usage in aer trace event
Message-ID: <20131210004016.GG31650@pd.tnic>
References: <1386476273-2418-1-git-send-email-rui.y.wang@intel.com>
 <20131208144312.GC4338@pd.tnic>
 <20131208150904.GD4338@pd.tnic>
 <CAErSpo7M=d0qMUCV2CCjkkbMX7h-xQcp0tuST89G_HefTQVoyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo7M=d0qMUCV2CCjkkbMX7h-xQcp0tuST89G_HefTQVoyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 04:41:18PM -0700, Bjorn Helgaas wrote:
> I think it's worthwhile to keep all three patches together, and I'd
> be happy to merge them via PCI. It looks like Joe had some good
> questions, so once you resolve them, I can merge them, or ack them and
> you can take them. I think either way will be fine.

So actually I'm only really interested in the first patch which clearly
fixes a minor issue in the PCIe AER tracepoint and that one I probably
should take through the RAS tree as the original patch adding the
tracepoint went through it too. Unless you really want to take it - then
be my guest! :-)

My intention with aerdrv_errprint.c was to cleanup some obvious stuff
which sprang at me while looking at the code, *without* *any* change in
functionality except the minor and obviously sensible

	s/aer_tlp_header:/TLP Header:/

replacement. (printk strings are not an API anyway).

If you're fine with those patches as they are right now, I can apply
them or you can take them or whatever. If not, then so be it.

If someone wants to diddle with what could be done better and more
readable, then that someone can do this at his own time - I don't really
want to waste mine.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
