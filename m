Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859Ab3GQS3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:29:08 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:58075 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab3GQS3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:29:06 -0400
Date: Wed, 17 Jul 2013 14:29:02 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Pawel Moll <pawel.moll@arm.com>, Jon Medhurst <tixy@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Olof Johansson <olof@lixom.net>, Achin Gupta <Achin.Gupta@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v5 0/1] drivers: mfd: Versatile Express SPC support
In-Reply-To: <20130717170038.GP24642@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.03.1307171416490.14924@syhkavp.arg>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com> <1374052705.3146.86.camel@hornet> <alpine.LFD.2.03.1307170825240.14924@syhkavp.arg> <1374067786.3146.123.camel@hornet> <alpine.LFD.2.03.1307171014510.14924@syhkavp.arg>
 <1374070811.3146.124.camel@hornet> <alpine.LFD.2.03.1307171148160.14924@syhkavp.arg> <20130717170038.GP24642@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Russell King - ARM Linux wrote:

> On Wed, Jul 17, 2013 at 11:57:55AM -0400, Nicolas Pitre wrote:
> > The sanest location at this point might simply be 
> > drivers/platform/vexpress_spc.c or drivers/platform/vexpress/spc.c 
> > depending on whether or not more such driver glue is expected in the 
> > vexpress future.  No point putting "arm" in the path, especially if this 
> > is later reused on arm64.
> 
> You wouldn't be making that argument if it were arch/arm64 and arch/arm32 -
> you'd probably be arguing that "arm" made perfect sense.

Well... in a sense: yes.  But in the end, having per arch directories 
under drivers/ is silly.  We already have per arch directories under 
arch/already.

> Don't get too hung up on names please, it's really not worth the time
> and effort being soo pedantic, and being soo pedantic leads to "pointless
> churn" when someone comes along and wants to pedantically change the
> names because it no longer matches the users.

At this point I don't really care about the name.  I just want the damn 
thing merged upstream.  But after several iterations to either fit one 
or another maintainers taste, each rework ends up in that maintainer 
saying: "Now that you've reworked the code, I still don't like it since 
this no longer fits in my subsystem tree."

In fact what we'd need at this point is 
drivers/code_that_no_subsystem_maintainers_wants/.  This is becoming 
overly ridiculous.


Nicolas
