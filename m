Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3HXDGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 23:06:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37227 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3HXDGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 23:06:33 -0400
Date: Sat, 24 Aug 2013 04:06:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Darren Hart <dvhart@linux.intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
Message-ID: <20130824030628.GA3668@srcf.ucam.org>
References: <1810269.JOHnJ0H7P9@vostro.rjw.lan>
 <20130822000306.GA21785@srcf.ucam.org>
 <1377300343.5259.84.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130823233805.GA1801@srcf.ucam.org>
 <1377301548.5259.91.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130824001345.GD14810@roeck-us.net>
 <20130824011036.GA2827@srcf.ucam.org>
 <20130824014723.GA17488@roeck-us.net>
 <20130824023806.GA3388@srcf.ucam.org>
 <521820A3.2010501@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521820A3.2010501@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 07:55:31PM -0700, Guenter Roeck wrote:

> Question is: Does this work _today_ with any existing driver, where
> one interrupt is served through ACPI and another as 'standard' Linux
> interrupt ? If yes, it must be working, and using fdt to describe
> the interrupt mapping for the non-ACPI interrupt should not make
> a difference. If no, the problem does not really have anything
> to do with fdt.

There's no such thing as an ACPI interrupt, it's just a data source in 
the same way that PnP used to be. _CRS refers to platform interrupts.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
