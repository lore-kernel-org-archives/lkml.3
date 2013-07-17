Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3GQOUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:20:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35308 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3GQOUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:20:16 -0400
Message-ID: <1374070811.3146.124.camel@hornet>
Subject: Re: [RFC PATCH v5 0/1] drivers: mfd: Versatile Express SPC support
From: Pawel Moll <pawel.moll@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Olof Johansson <olof@lixom.net>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Date: Wed, 17 Jul 2013 15:20:11 +0100
In-Reply-To: <alpine.LFD.2.03.1307171014510.14924@syhkavp.arg>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
	 <1374052705.3146.86.camel@hornet>
	 <alpine.LFD.2.03.1307170825240.14924@syhkavp.arg>
	 <1374067786.3146.123.camel@hornet>
	 <alpine.LFD.2.03.1307171014510.14924@syhkavp.arg>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 17 Jul 2013 14:20:12.0322 (UTC) FILETIME=[BFE41820:01CE82F8]
X-MC-Unique: 113071715201401201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 15:16 +0100, Nicolas Pitre wrote:
> On Wed, 17 Jul 2013, Pawel Moll wrote:
> 
> > On Wed, 2013-07-17 at 13:33 +0100, Nicolas Pitre wrote:
> > > If this is really miscelaneous code that really doesn't fit 
> > > anywhere else, it should rather go into drivers/misc/ as a last resort.
> > 
> > Interestingly enough drivers/misc was my first choice for all the
> > vexpress stuff, but it wasn't received well...
> > 
> > Anyway, the SPC driver as it is now seem to be a "power management
> > system driver". Maybe a relevant directory would be in place? Wouldn't
> > PSCI belong there as well? (there are two psci.c files in arch/arm and
> > arch/arm64, surprisingly similar ones ;-)
> > 
> > The bottom line is: today it is not an MFD driver.
> 
> But we know it will, right?  So better  save some churn by storing the 
> initial code where it would end up anyway once complete.

Not in that form, no. The code living in mfd will just register
mfd_cells while "functional" parts are going to live elsewhere. This is
how I understand what Samuel asked me to do and that's what is happening
to vexpress-sysreg now.

Paweł


