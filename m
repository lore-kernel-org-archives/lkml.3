Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaL3PTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:19:08 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59716 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaL3PTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:19:05 -0500
Date: Tue, 30 Dec 2014 15:18:02 +0000
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andreas.noever@gmail.com" <andreas.noever@gmail.com>,
        "crmafra2@gmail.com" <crmafra2@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
Subject: Re: Bisected regression from 3.17 still present in 3.19-rc1
Message-ID: <20141230151459.GA1809@linux-g29b.site>
References: <20141228185409.GA2015@linux-g29b.site>
 <1419902900.25226.0.camel@nebula.com>
 <20141230101624.GA5339@linux-g29b.site>
 <1419939412.25226.2.camel@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419939412.25226.2.camel@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2014 at 11:36:53 +0000, Matthew Garrett wrote:
> On Tue, 2014-12-30 at 10:16 +0000, Carlos R. Mafra wrote:
> > On Tue, 30 Dec 2014 at  1:28:21 +0000, Matthew Garrett wrote:
> > > What is CONFIG_ACPI_SBS set to?
> > 
> > CONFIG_ACPI_SBS is not set
> 
> There's your problem. The Darwin call results in the firmware exposing
> the battery via SBS, not as an ACPI control method battery. Enable
> CONFIG_ACPI_SBS and you should be good.

Right, enabling CONFIG_ACPI_SBS makes it work again, thanks!

