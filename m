Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab3HOTnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:43:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38606 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab3HOTnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:43:12 -0400
Date: Thu, 15 Aug 2013 21:43:09 +0200
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
Message-ID: <20130815194309.GL27616@pd.tnic>
References: <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com>
 <20130813175809.GE4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB8F53@ORSMSX106.amr.corp.intel.com>
 <20130813181004.GF4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB9150@ORSMSX106.amr.corp.intel.com>
 <20130814054322.GA9158@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CBAAFA@ORSMSX106.amr.corp.intel.com>
 <20130815101432.GE27616@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CBD158@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CBD158@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 07:14:34PM +0000, Luck, Tony wrote:
> Yes - but the serial port is too slow to log everything that you might
> conceivably need to debug your problem. Imagine trying to log every
> interrupt and every pagefault on every processor down a single 115200
> baud connection. Thus my earlier comments about guessing what to log.

Right, but a normally sized dmesg usually gets through ok. Selecting
what to log could be a very tedious and error-prone process...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
