Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3AYOqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:46:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42353 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3AYOqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:46:36 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: Koen Kooi <koen@dominion.thruhere.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "eballetbo@gmail.com" <eballetbo@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "linux-omap@vger.kernel.org List" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v1 0/6] USB: Add support for multiple PHYs of same type
Thread-Topic: [PATCH v1 0/6] USB: Add support for multiple PHYs of same type
Thread-Index: AQHN+IcwvzF5Bpzvl0aL3abwJ4uoyphVIJQAgAABCoCAAAjQgIAADPUAgAG5MuD//612gIABwaqAgAHB2rA=
Date: Fri, 25 Jan 2013 14:46:09 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA93ACE@DBDE01.ent.ti.com>
References: <1358848694-20145-1-git-send-email-kishon@ti.com>
 <2D906ABA-71F2-4843-9DBE-F82527A1240A@dominion.thruhere.net>
 <50FEB3FD.3050001@ti.com> <50FEBB61.9000707@ti.com>
 <B9531499-0746-44DA-BDBB-999D4CA31E63@dominion.thruhere.net>
 <C8443D0743D26F4388EA172BF4E2A7A93EA922F5@DBDE01.ent.ti.com>
 <50FFF31D.2070908@ti.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EA92B0B@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA92B0B@DBDE01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.49]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On Thu, Jan 24, 2013 at 17:21:45, Mohammed, Afzal wrote:
> On Wed, Jan 23, 2013 at 19:56:37, ABRAHAM, KISHON VIJAY wrote:
> > On Wednesday 23 January 2013 07:28 PM, Mohammed, Afzal wrote:

> > > USB first instance of am335x works in mainline as of now.
> 
> > Can you check if this series indeed breaks am335x?
> > 
> > Thanks for your help.
> 
> Do you have a tree having these changes, it would be easier for me.

I tried with your "omap5-with-palmas" branch that was mentioned in
the cover letter of your latest series (but couldn't find the commit
that you mentioned in the cover letter, HEAD of that branch that I
tested was "2c29519 ARM: dts: palmas: update dt data for palmas-usb")

usb first instance of am335x works as earlier.

Regards
Afzal

