Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaHDTkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:40:19 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:58618 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaHDTkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:40:17 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Nick Krause <xerofoify@gmail.com>
Subject: RE: Kernel Debugging Support
Thread-Topic: Kernel Debugging Support
Thread-Index: AQHPsAOl9PQyvd4f5kSzwCznguzEvpvAzZxggAAFdLmAAAMHoA==
Date: Mon, 4 Aug 2014 19:40:15 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C4061@US01WEMBX2.internal.synopsys.com>
References: <CAPDOMVj5nifG8VQBB_UzNESBc+arxpCQ5sEOAYdb6Rr-KkDSHw@mail.gmail.com>
 <20140804164633.GA28436@xanatos>
            <A2CA0424C0A6F04399FB9E1CD98E0304844C4028@US01WEMBX2.internal.synopsys.com>
 <58974.1407180184@turing-police.cc.vt.edu>
In-Reply-To: <58974.1407180184@turing-police.cc.vt.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> Sent: Monday, August 04, 2014 12:23 PM
> 
> On Mon, 04 Aug 2014 19:07:53 -0000, Paul Zimmerman said:
> 
> > Are you sure about that? Last I heard, xHCI debug support was a logo
> > requirement from Microsoft for Windows 8 and above, so I would have
> > thought that most vendors would have implemented it by now.
> 
> There's a lot of gear out in the real world that was manufactured before
> Windows 8 was released.
> 
> And the actual requirement, as listed at:
> 
> http://msdn.microsoft.com/en-us/library/windows/hardware/jj128256
> 
> doesn't actually require USB debug -it requires a debug port, and xHCI
> is below ethernet on the preference list.  As it says:
> 
> ---
> The next version of Windows will support several different debug transports.
> They are listed below in the preferred order of implementation.
> 
> Hardware Debugging Transports
> 
> Ethernet Network Interface Card from the supported list: http://msdn.microsoft.com/en-
> us/library/windows/hardware/hh830880
> 
> USB 3.0 - xHCI controller compliant to xHCI debug specification.
> 
> 1394 OHCI compliant Firewire controllers.
> 
> USB2 OTG (on supported hardware for Windows, recommend XHCI debug instead).
> 
> USB 2.0 EHCI debug (the debug enabled port must be user accessible). Legacy Serial (16550 compatible
> programming interface).

Ah, you didn't read far enough down the page :)

---
System.Fundamentals.DebugPort.USB.SystemExposesDebugInterfaceUsb
USB 3 system exposes debug interface that complies with Debug Port Specification
 
Target Feature
 System.Fundamentals.DebugPort.USB
 
Applies to
 Windows 8 Client x86, x64, ARM (Windows RT)
 Windows 8.1 Client x86, x64, ARM (Windows RT 8.1)
 Windows Server 2012 R2 x64
 Windows Server 2012 x64

Description

Systems that support USB 3 are required to have xHCI controller(s) compliant to the xHCI debug specification. The xHCI controller(s) shall be memory mapped.

There must be at least one user accessible USB 3.0 debug port on the machine.

...

Enforcement Date
 Mar. 01, 2012
---

So I have to believe there are a *lot* of systems out there that do support xHCI debug.

-- 
Paul

