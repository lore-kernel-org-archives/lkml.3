Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab3A1FCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 00:02:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36353 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3A1FCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 00:02:11 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "tony@atomide.com" <tony@atomide.com>, "hs@denx.de" <hs@denx.de>,
        "Girdwood, Liam" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH 5/6] ARM: regulator: add tps6507x device tree data
Thread-Topic: [PATCH 5/6] ARM: regulator: add tps6507x device tree data
Thread-Index: AQHN+iEtFgtHOPSvUE6bkenLPvEY85hYBHKAgAGPHNCAASNcAIADfKmA
Date: Mon, 28 Jan 2013 05:01:36 +0000
Message-ID: <A4887BF146CD57468F700B415D2F470158173C@DBDE01.ent.ti.com>
References: <1359024920-32190-1-git-send-email-manishv.b@ti.com>
 <1359024920-32190-6-git-send-email-manishv.b@ti.com>
 <20130124120050.GP4955@opensource.wolfsonmicro.com>
 <A4887BF146CD57468F700B415D2F4701581621@DBDE01.ent.ti.com>
 <20130126051206.GE10580@opensource.wolfsonmicro.com>
In-Reply-To: <20130126051206.GE10580@opensource.wolfsonmicro.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 10:42:08, Mark Brown wrote:
> On Fri, Jan 25, 2013 at 06:29:49AM +0000, Vishwanathrao Badarkhe, Manish wrote:
> > On Thu, Jan 24, 2013 at 17:30:51, Mark Brown wrote:
> 
> > I too doubt that whether it should be in architecture specific folder,
> 
> > My code is in reference to below patch:
> > arm/dts: regulator: Add tps65910 device tree 
> > data(d5d08e2e1672da627d7c9d34a9dc1089c653e23a)
> 
> > Could you please suggest me if it can be moved somewhere else?
> 
> We should have somewhere to put this sort of generic stuff, yes.  Not sure where, possibly under drivers/of or some non-drivers part of the tree.
> 

Right now, nobody has put this kind of generic stuff other than architecture folder. 
Later on We can move these kind of generic stuff somewhere else in one shot.


Regards, 
Manish
