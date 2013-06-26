Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3FZHRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:17:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:41739 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab3FZHRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:17:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="322711411"
Message-ID: <1372231052.8177.68.camel@envy.home>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
From: Darren Hart <dvhart@linux.intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Olof Johansson <olof@lixom.net>, "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr@intel.com" <peter.p.waskiewicz.jr@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.intel.com>,
        "danders@circuitco.com" <danders@circuitco.com>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Date: Wed, 26 Jun 2013 00:17:32 -0700
In-Reply-To: <1372224988.9179.5.camel@x230>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
	 <20130626040026.GA23621@quad.lixom.net>
	 <1372221808.8177.52.camel@envy.home> <1372222365.9179.4.camel@x230>
	 <1372224736.8177.63.camel@envy.home> <1372224988.9179.5.camel@x230>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 05:36 +0000, Matthew Garrett wrote:
> On Tue, 2013-06-25 at 22:32 -0700, Darren Hart wrote:
> 
> > are all board-specific. They map GPIO to their fixed functions and
> > provide an API for board-specific queries (minnowboard.c), they provide
> > example uses (minnowboard-gpio and minnowboard-keys) which aid in
> > experimentation and the development of new drivers.
> > 
> > Which of these make sense as ACPI devices in your opinion?
> 
> Does the firmware contain a corresponding ACPI device with a specific
> _HID that defines the programming model? If so, it should have an ACPI
> driver. If not, it shouldn't.

It does not currently. However, the firmware is being developed along
with the hardware and the OS. We have the opportunity to do whatever
makes the most sense.

My next-steps here were to get a basic ACPI ID setup for each of the
three drivers just so they could be enumerated over ACPI rather than
just loaded manually. Beyond that I'll be looking to Len and Rafael for
guidance.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

