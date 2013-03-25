Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3CYFGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 01:06:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46756 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441Ab3CYFGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 01:06:20 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rob@landley.net" <rob@landley.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH 0/2] Add dT support for tps6507x touchscreen.
Thread-Topic: [PATCH 0/2] Add dT support for tps6507x touchscreen.
Thread-Index: AQHOJ8YpeyXeRdkAtUCRclb5rD6P55i121Vw
Date: Mon, 25 Mar 2013 05:06:03 +0000
Message-ID: <A4887BF146CD57468F700B415D2F4701585C7C@DBDE01.ent.ti.com>
References: <1364043571-9210-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1364043571-9210-1-git-send-email-manishv.b@ti.com>
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

Hi all
I am sending next version for this, as need to update commit message for 
some patches.

Thanks
Manish Badarkhe

-----Original Message-----
From: Vishwanathrao Badarkhe, Manish 
Sent: Saturday, March 23, 2013 6:29 PM
To: devicetree-discuss@lists.ozlabs.org; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; davinci-linux-open-source@linux.davincidsp.com; linux-doc@vger.kernel.org
Cc: dmitry.torokhov@gmail.com; rob@landley.net; rob.herring@calxeda.com; grant.likely@secretlab.ca; Vishwanathrao Badarkhe, Manish
Subject: [PATCH 0/2] Add dT support for tps6507x touchscreen.

Patch set adds DT support for tps6507x based touchscreen
Also, add DT data for tps6507x touchscreen in da850-evm by 
providing touchscreen node inside tps6507x mfd device.

This patch series applies on top of v3.9-rc2 of linus tree and
depends on [1].  

[1]davinci: Add device tree data for tps6507x
   http://www.spinics.net/lists/linux-doc/msg09473.html
 
Tested on da850-evm board.

Vishwanathrao Badarkhe, Manish (2):
  tps6507x-ts: Add DT support
  ARM: davinci: da850: add tps6507x touchscreen DT data

 Documentation/devicetree/bindings/mfd/tps6507x.txt |   22 ++++
 arch/arm/boot/dts/da850-evm.dts                    |    9 ++
 drivers/input/touchscreen/tps6507x-ts.c            |  104 ++++++++++++++------
 3 files changed, 105 insertions(+), 30 deletions(-)

-- 
1.7.4.1

