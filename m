Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3EaGE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:04:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49663 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3EaGEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:04:49 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>
Subject: RE: [PATCH V3 0/2] Add DT support for tps6507x touchscreen
Thread-Topic: [PATCH V3 0/2] Add DT support for tps6507x touchscreen
Thread-Index: AQHOVgCI6izTHA2740yHd1GR/6IyMJkexdQA
Date: Fri, 31 May 2013 06:04:32 +0000
Message-ID: <A4887BF146CD57468F700B415D2F470159C239@DBDE04.ent.ti.com>
References: <1369126458-24872-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1369126458-24872-1-git-send-email-manishv.b@ti.com>
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

Hi Dmitry
Please let me know, are there any review comments on this patch series?

Thanks
Manish Badarkhe

On Tue, May 21, 2013 at 14:24:16, Vishwanathrao Badarkhe, Manish wrote:
> Patch set adds DT support for tps6507x based touchscreen.
> Also, add DT data for tps6507x touchscreen in da850-evm by
> providing touchscreen node inside tps6507x mfd device.
> 
> This patch series applies on top of linux-next tree and depends on [1].
> 
> [1]tps6507x-ts: update to devm_* API
>    https://patchwork.kernel.org/patch/2324441/
> 
> Tested on da850-evm board.
> 
> Changes since V2:
>  - Updated tps6507x documentation.
>  - Removed unnecessary code.
> 
> Changes since V1:
>  - Updated tps6507x documentation.
>  - Updated commit message.
>  - return proper error value in absence platform and DT data
>    for touchscreen.
> 
> Vishwanathrao Badarkhe, Manish (2):
>   tps6507x-ts: Add DT support
>   ARM: davinci: da850: add tps6507x touchscreen DT data
> 
>  Documentation/devicetree/bindings/mfd/tps6507x.txt |   28 ++++++-
>  arch/arm/boot/dts/da850-evm.dts                    |    9 ++
>  drivers/input/touchscreen/tps6507x-ts.c            |   98 ++++++++++++++------
>  3 files changed, 104 insertions(+), 31 deletions(-)
> 
> -- 
> 1.7.4.1
> 
> 


Regards, 
Manish
