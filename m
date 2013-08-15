Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab3HOTlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:41:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38565 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867Ab3HOTlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:41:05 -0400
Date: Thu, 15 Aug 2013 21:41:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130815194103.GK27616@pd.tnic>
References: <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com>
 <20130813175809.GE4077@pd.tnic>
 <520B6282.6030906@linux.vnet.ibm.com>
 <20130814212211.544ee6a4@concha.lan>
 <20130815093831.GA27616@pd.tnic>
 <20130815102607.7168a930@samsung.com>
 <20130815134454.GF27616@pd.tnic>
 <20130815111407.4080a744@samsung.com>
 <3908561D78D1C84285E8C5FCA982C28F31CBD184@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CBD184@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 07:20:29PM +0000, Luck, Tony wrote:
> In theory it could. The ACPI generic error structure used to report
> includes a 20-byte free format field which a BIOS could use to
> describe the location of the error. Haven't seen anyone do this yet -
> and our internal BIOS people looked at me like I was crazy to suggest
> such a thing. But I still entertain hopes that some OEM will do the
> right thing and raise the bar of usefulness.

Sadly, I can report similar experiences.

I did try to get the RAS hw people persuaded that spitting out the DIMM
mapping is best done by the BIOS because it has that info already -
it is a matter of carrying it out. Alas, more important events took
place... :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
-- 
