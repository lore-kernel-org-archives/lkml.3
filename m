Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaHDTH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:07:57 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:43008 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaHDTHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:07:55 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Nick Krause <xerofoify@gmail.com>
Subject: RE: Kernel Debugging Support
Thread-Topic: Kernel Debugging Support
Thread-Index: AQHPsAOl9PQyvd4f5kSzwCznguzEvpvAzZxg
Date: Mon, 4 Aug 2014 19:07:53 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C4028@US01WEMBX2.internal.synopsys.com>
References: <CAPDOMVj5nifG8VQBB_UzNESBc+arxpCQ5sEOAYdb6Rr-KkDSHw@mail.gmail.com>
 <20140804164633.GA28436@xanatos>
In-Reply-To: <20140804164633.GA28436@xanatos>
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

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Sarah Sharp
> Sent: Monday, August 04, 2014 9:47 AM
> 
> Please Cc the new xHCI driver maintainer, Mathias Nyman.  I'm officially
> retired from USB development and have moved onto other projects. :)
> 
> > After reading around seems people want support for usb debugging in
> > kgdb or other usb based solutions.
> 
> Yes, early boot USB debug over xHCI has been a low-priority feature
> request.
> 
> Unfortunately, USB debug is an optional feature for xHCI host
> controllers, so many of them don't have USB debug ports.  Even if it is
> included, the USB debug ports are often either routed to internal USB
> ports or not exposed on the board altogether.  Since it's not widely
> available, it's not a high priority to implement.

Hi Sarah,

Are you sure about that? Last I heard, xHCI debug support was a logo
requirement from Microsoft for Windows 8 and above, so I would have
thought that most vendors would have implemented it by now. I know
Synopsys put a lot of effort into making sure it works in our IP. Or
did Microsoft relax that requirement at the last minute?

-- 
Paul

