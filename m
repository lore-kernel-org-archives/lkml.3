Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3HXBr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 21:47:28 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54022 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3HXBr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 21:47:26 -0400
Date: Fri, 23 Aug 2013 18:47:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Darren Hart <dvhart@linux.intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
Message-ID: <20130824014723.GA17488@roeck-us.net>
References: <20130820192650.GA19470@srcf.ucam.org>
 <6438184.2yT2NMB1CE@vostro.rjw.lan>
 <20130821233942.GA21502@srcf.ucam.org>
 <1810269.JOHnJ0H7P9@vostro.rjw.lan>
 <20130822000306.GA21785@srcf.ucam.org>
 <1377300343.5259.84.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130823233805.GA1801@srcf.ucam.org>
 <1377301548.5259.91.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130824001345.GD14810@roeck-us.net>
 <20130824011036.GA2827@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824011036.GA2827@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 02:10:36AM +0100, Matthew Garrett wrote:
> On Fri, Aug 23, 2013 at 05:13:45PM -0700, Guenter Roeck wrote:
> 
> > Did the group conclude that the idea of FDT augmenting ACPI is not feasible ? 
> 
> I think expressing FDT in ACPI is feasible, I'm just not sure it's 
> desirable. We'd still end up with duplicate information and no mechanism 
> for drivers to handle both.
> 
Not sure I understand what you are saying. My understanding of "augment"
would be that there is ACPI information, and there is a separate FDT
(or an FDT overlay) providing additional information. There should be
no duplicate information in this model.

Guenter
