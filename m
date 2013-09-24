Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3IXPzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:55:38 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:33609
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab3IXPzh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:55:37 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1380038126.13235.12.camel@atx-linux-37>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Alan Tull <atull@altera.com>
To: Michal Simek <monstr@monstr.eu>
CC: Pavel Machek <pavel@denx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Date: Tue, 24 Sep 2013 10:55:26 -0500
In-Reply-To: <1379710523.21515.4.camel@atx-linux-37>
References: <cover.1379519753.git.michal.simek@xilinx.com>
	 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
	 <20130918191517.GQ19937@titan.lakedaemon.net>
	 <20130918203247.GA11181@obsidianresearch.com>
	 <1379539063.31417.23.camel@atx-linux-37>
	 <20130919100833.GC19346@amd.pavel.ucw.cz> <523AD9C5.8060006@monstr.eu>
	 <1379710523.21515.4.camel@atx-linux-37>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I have ported the altera fpga manager driver to work with your version
> of the fpga manager framework.  It works fine if I use the
> firmware_class.c's built-in support to load the firmware, but not with a
> userspace helper.
> 


Hi Michal,

I cleaned up my udev rules and now I see the userspace helper working.
Just adding one udev rule that points to the standard hotplug-script was
sufficient to see the userspace script working nicely.  

All in all, the firmware interface seems pretty easy to use and it gives
us the flexibility to either use the kernel to load the firmware or to
use scripts, so it should work with a variety of use cases.

Since we are arriving at a solution that is suitable for the both of us,
I expect you will be able to add Dinh and myself as maintainers here,
right?  I have no problem with there only being one repo to store
patches for this subsystem.

Alan






