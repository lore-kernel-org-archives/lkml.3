Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaJWBZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 21:25:52 -0400
Received: from mail-bl2on0135.outbound.protection.outlook.com ([65.55.169.135]:54000
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202AbaJWBZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 21:25:50 -0400
From: Dudley Du <dudl@cypress.com>
To: "'dmitry.torokhov@gmail.com'" <dmitry.torokhov@gmail.com>,
        "'rydberg@euromail.se'" <rydberg@euromail.se>
CC: "'bleung@google.com'" <bleung@google.com>,
        "'patrikf@google.com'" <patrikf@google.com>,
        "'linux-input@vger.kernel.org'" <linux-input@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        David Solda <dso@cypress.com>
Subject: RE: [PATCH v8 00/13] input: cyapa: intruction of cyapa patches
Thread-Topic: [PATCH v8 00/13] input: cyapa: intruction of cyapa patches
Thread-Index: Ac/tlhWHE+MFpOnvS3qaig+FKBixaQ==
Date: Thu, 23 Oct 2014 01:25:45 +0000
Message-ID: <5a3eeff037d14e3ba96376a7459e4478@BN1PR06MB070.namprd06.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [140.207.206.26]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB070;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51164003)(164054003)(51704005)(13464003)(76482002)(99396003)(120916001)(31966008)(54356999)(40100003)(122556002)(33646002)(87936001)(2656002)(85852003)(108616004)(107046002)(95666004)(99286002)(106356001)(76576001)(101416001)(77096002)(74316001)(105586002)(46102003)(80022003)(85306004)(86362001)(64706001)(97736003)(20776003)(92566001)(19580405001)(21056001)(50986999)(19580395003)(4396001)(66066001)(24736002)(491001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB070;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB053;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

It has been long time after the v8 patches submitted, with your busy time, could you help take a little time to update the status of the schedule or reviews?
Any information will halp a lot.

Thanks,
Dudley

> -----Original Message-----
> From: Dudley Du
> Sent: 2014?10?20? 9:16
> To: 'Dudley Du'; dmitry.torokhov@gmail.com; rydberg@euromail.se
> Cc: bleung@google.com; patrikf@google.com; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 00/13] input: cyapa: intruction of cyapa patches
>
> Hi Dmitry,
>
> Is there any update on the v8 patchs for input cyapa trackpad drivers?
>
> Thanks,
> Dudley
>
> > -----Original Message-----
> > From: Dudley Du [mailto:dudley.dulixin@gmail.com]
> > Sent: 2014?10?15? 15:19
> > To: dmitry.torokhov@gmail.com; rydberg@euromail.se
> > Cc: Dudley Du; bleung@google.com; patrikf@google.com;
> > linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH 00/13] input: cyapa: intruction of cyapa patches
> >
> > Based on Dmitry's comments, I made v8 patches of cyapa trackpad device
> > with below updates compared with v7 patches:
> > 1) [PATCH v8 01/13] - Remove the async thread for device detect in
> >    proble routine, now the device detect process is completly done within
> >    the device proble routine.
> > 2) [PATCH v8 01/13] - Split the irq cmd hander function to separated
> >    function cyapa_default_irq_cmd_handler() and set it to interface
> >    cyapa_default_ops.irq_cmd_handler.
> > 3) [PATCH v8 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
> >    to avoid miss-enter when device protocol is still in detecting.
> >
> >
> > V7 patches have below updates compared with v6 patches:
> > 1) [PATCH v7 01/13] - Split the irq cmd hander function to separated
> >    function cyapa_default_irq_cmd_handler() and set it to interface
> >    cyapa_default_ops.irq_cmd_handler.
> > 2) [PATCH v7 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
> >    to avoid miss-enter when device protocol is still in detecting.
> >
> >
> > V6 patches have below updates compared with v5 patches:
> > 1) Remove patch 14 of the lid filtering from the cyapa driver.
> >
> > V5 patches have below updates compared with v4 patches:
> > 1) Uses get_device()/put_device() instead of kobject_get()/kobject_put();
> > 2) Fix memories freed before debugfs entries issue;
> > 3) Make cyapa_debugs_root valid in driver module level
> >    in module_init()/moudle_exit() ;
> > 4) Fix i2c_transfer() may return partial transfer issues.
> > 5) Add cyapa->removed flag to avoid detecting thread may still running
> >    when driver module is removed.
> > 6) Fix the meanings of some comments and return error code not clear issue.
> >
> > This patch set is aimed to re-architecture the cyapa driver to support
> > old gen3 trackpad device and new gen5 trackpad device in one
> > cyapa driver for easily productions support based on
> > customers' requirements, and add sysfs functions and interfaces
> > supported that required by users and customers.
> > Because the earlier gen3 and the latest gen5 trackpad devies using
> > two different chipsets, and have different protocol and interfaces.
> > If supported these two trackpad devices in two different drivers, then
> > it will be difficult to manage productions and later firmware updates.
> > it will cause customer don't know which one to use and update
> > because these two trackpad devices have been used and integrated
> > in same one productions at a time, so must to support these two trackpad
> > devices in same on driver.
> >
> > The new architecture is made of:
> > cyapa.c - the core of the architecture, supply interfaces and
> > functions to system and read trackpad devices.
> > cyapa.h - header file including macros and data structure definitions.
> > cyapa_gen3.c - functions support for gen3 trackpad devices,
> > cyapa_gen5.c - functions support for gen5 trackpad devices.
> >
> > Beside this introduction patch, it has 14 patches listed as below.
> > For these patches each one is patched based on previous one.
> >
> > patch 1/13: re-architecture cyapa driver with core functions,
> > and applying the device detecting function in async thread to speed
> > up system boot time.
> >
> > patch 2/13: add cyapa driver power management interfaces support.
> >
> > patch 3/13: add cyapa driver runtime power management interfaces support.
> >
> > patch 4/13: add cyapa key function interfaces in sysfs system.
> > Including read firmware version, get production ID, read baseline,
> > re-calibrate trackpad baselines and do trackpad firmware update.
> >
> > patch 5/13: add read firmware image and read raw trackpad device'
> > sensors' raw data interface in debugfs system.
> >
> > patch 6/13: add gen3 trackpad device basic functions support.
> >
> > patch 7/13: add gen3 trackpad device firmware update function support.
> >
> > patch 8/13: add gen3 trackpad device report baseline and do force
> > re-calibrate functions support.
> >
> > patch 9/13: add gen3 trackpad device read firmware image function support.
> >
> > patch 10/13: add gen5 trackpad device basic functions support.
> >
> > patch 11/13: add gen5 trackpad device firmware update function support.
> >
> > patch 12/13: add gen5 trackpad device report baseline and do force
> > re-calibrate functions support.
> >
> > patch 13/13: add gen5 trackpad device read firmware image and report
> > sensors' raw data values functions support.
> >
> > This message and any attachments may contain Cypress (or its subsidiaries)
> > confidential information. If it has been received in error, please advise the sender
> > and immediately delete this message.

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
