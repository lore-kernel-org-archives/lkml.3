Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3HXBKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 21:10:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36583 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3HXBKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 21:10:42 -0400
Date: Sat, 24 Aug 2013 02:10:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Darren Hart <dvhart@linux.intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
Message-ID: <20130824011036.GA2827@srcf.ucam.org>
References: <20130820192650.GA19470@srcf.ucam.org>
 <6438184.2yT2NMB1CE@vostro.rjw.lan>
 <20130821233942.GA21502@srcf.ucam.org>
 <1810269.JOHnJ0H7P9@vostro.rjw.lan>
 <20130822000306.GA21785@srcf.ucam.org>
 <1377300343.5259.84.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130823233805.GA1801@srcf.ucam.org>
 <1377301548.5259.91.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130824001345.GD14810@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824001345.GD14810@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:13:45PM -0700, Guenter Roeck wrote:

> Did the group conclude that the idea of FDT augmenting ACPI is not feasible ? 

I think expressing FDT in ACPI is feasible, I'm just not sure it's 
desirable. We'd still end up with duplicate information and no mechanism 
for drivers to handle both.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
