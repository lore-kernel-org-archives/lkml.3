Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab3HMSKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:10:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41313 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819Ab3HMSKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:10:06 -0400
Date: Tue, 13 Aug 2013 20:10:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130813181004.GF4077@pd.tnic>
References: <20130808163822.67e0828a@samsung.com>
 <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com>
 <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812125343.GE18018@pd.tnic>
 <520A16BD.30201@linux.vnet.ibm.com>
 <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com>
 <20130813175809.GE4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB8F53@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CB8F53@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 06:05:02PM +0000, Luck, Tony wrote:
> If the errors are serious (or a precursor to something serious) that
> process may never get the chance to save the log.

What about sending tracepoint data over serial and/or network? I agree
that dmesg over serial would be helpful but we need a similar sure-fire
way for carrying error info out.

Which reminds me, pstore could also be a good thing to use, in addition.
Only put error info there as it is limited anyway.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
