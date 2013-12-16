Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3LPV0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:26:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:55069 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab3LPV0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:26:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,497,1384329600"; 
   d="scan'208";a="328307853"
Date: Mon, 16 Dec 2013 13:31:02 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] x86: intel-mid: remove deprecated X86_MDFLD and
 X86_WANT_INTEL_MID configs
Message-ID: <20131216213102.GD17264@psi-dev26.jf.intel.com>
References: <1387224459-25746-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387224459-25746-5-git-send-email-david.a.cohen@linux.intel.com>
 <CAErSpo5tM4nF-WuUb9CH6sZ+XJ3u_U5nwg9u2cbn0EmeG1OgLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5tM4nF-WuUb9CH6sZ+XJ3u_U5nwg9u2cbn0EmeG1OgLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn,

[snip]

> It'd be nice to know what "MID" means -- from Googling, I guess
> "Mobile Internet Device."

Yes, that's correct. Wikipedia explains it:
http://en.wikipedia.org/wiki/Mobile_Internet_device

I'll prepare a patch adding intel mid to Documentation/ as soon as I have
time for it.

Br, David Cohen

