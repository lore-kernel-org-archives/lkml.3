Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3G1NTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 09:19:21 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59921 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3G1NTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 09:19:19 -0400
Date: Sun, 28 Jul 2013 15:19:03 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130728131901.GA8864@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1441731.8CGUI1tUxh@flatron>
 <20130728085650.GA4683@netboy>
 <1416484.XDfk5G56BI@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416484.XDfk5G56BI@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 11:12:53AM +0200, Tomasz Figa wrote:

> I'm not really sure what effect on users this has. Maybe you should define 
> "users".

...

> Care to explain this reasoning?

Use Case
~~~~~~~~

User acquires a machine running ARM Linux version 3.x, with u-boot
and dtb in a read only flash partition. The board boots and works just
fine. However, for his application, the user requires a new kernel
feature that appeared in version 3.y where y > x. He compiles the new
kernel, and it also works.

Thanks,
Richard



