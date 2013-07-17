Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab3GQRBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:01:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37297 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab3GQRBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:01:49 -0400
Date: Wed, 17 Jul 2013 18:00:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Jon Medhurst <tixy@linaro.org>,
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
Message-ID: <20130717170038.GP24642@n2100.arm.linux.org.uk>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com> <1374052705.3146.86.camel@hornet> <alpine.LFD.2.03.1307170825240.14924@syhkavp.arg> <1374067786.3146.123.camel@hornet> <alpine.LFD.2.03.1307171014510.14924@syhkavp.arg> <1374070811.3146.124.camel@hornet> <alpine.LFD.2.03.1307171148160.14924@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1307171148160.14924@syhkavp.arg>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 11:57:55AM -0400, Nicolas Pitre wrote:
> The sanest location at this point might simply be 
> drivers/platform/vexpress_spc.c or drivers/platform/vexpress/spc.c 
> depending on whether or not more such driver glue is expected in the 
> vexpress future.  No point putting "arm" in the path, especially if this 
> is later reused on arm64.

You wouldn't be making that argument if it were arch/arm64 and arch/arm32 -
you'd probably be arguing that "arm" made perfect sense.

Don't get too hung up on names please, it's really not worth the time
and effort being soo pedantic, and being soo pedantic leads to "pointless
churn" when someone comes along and wants to pedantically change the
names because it no longer matches the users.
