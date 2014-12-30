Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaL3KLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:11:09 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58225 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaL3KLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:11:08 -0500
Date: Tue, 30 Dec 2014 10:16:24 +0000
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "crmafra2@gmail.com" <crmafra2@gmail.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andreas.noever@gmail.com" <andreas.noever@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
Subject: Re: Bisected regression from 3.17 still present in 3.19-rc1
Message-ID: <20141230101624.GA5339@linux-g29b.site>
References: <20141228185409.GA2015@linux-g29b.site>
 <1419902900.25226.0.camel@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419902900.25226.0.camel@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2014 at  1:28:21 +0000, Matthew Garrett wrote:
> On Sun, 2014-12-28 at 18:54 +0000, Carlos R. Mafra wrote:
> > The laptop is a 2-year-old macbook Pro with retina display.
> > 
> > I use a dockapp called wmlaptop2 (http://repo.or.cz/w/wmlaptop2.git)
> > which, among other things, displays battery information (% of charge
> > remaining etc).
> > 
> > With the kernel v3.17 the battery information stopped working and it
> > still does not work in the latest v3.19-rc1.
> 
> What is CONFIG_ACPI_SBS set to?

CONFIG_ACPI_SBS is not set
