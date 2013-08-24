Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3HXEvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 00:51:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38054 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3HXEvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 00:51:44 -0400
Date: Sat, 24 Aug 2013 05:51:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Darren Hart <dvhart@linux.intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
Message-ID: <20130824045139.GA4840@srcf.ucam.org>
References: <1377300343.5259.84.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130823233805.GA1801@srcf.ucam.org>
 <1377301548.5259.91.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130824001345.GD14810@roeck-us.net>
 <20130824011036.GA2827@srcf.ucam.org>
 <20130824014723.GA17488@roeck-us.net>
 <20130824023806.GA3388@srcf.ucam.org>
 <521820A3.2010501@roeck-us.net>
 <20130824030628.GA3668@srcf.ucam.org>
 <52183A56.5020707@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52183A56.5020707@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 09:45:10PM -0700, Guenter Roeck wrote:

> "What happens when you have an ACPI device that contains an interrupt in
>  _CRS and contains a different interrupt in an embedded FDT block?"
> 
> Does the situation occur today, ie does it ever happen that one interrupt
> for a device is specified (if that is the correct term) in _CRS and
> another by some other means ?

The only case I can think of is PCI, where we ignored the ACPI-provided 
resources until fairly recently. That was a somewhat reasonable thing to 
do, since the hardware still had to support pre-ACPI operating systems 
and so the non-ACPI information sources were typically correct.

Other than that, I think we always trust the ACPI data.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
