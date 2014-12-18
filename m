Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaLRLGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:06:46 -0500
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:26624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751466AbaLRLGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:06:44 -0500
From: Dudley Du <dudl@cypress.com>
To: Dudley Du <dudl@cypress.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "jmmahler@gmail.com" <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>
CC: "bleung@google.com" <bleung@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQGqmcizaS/V/Z90+9ZdsIRkHnfZyVLzdA
Date: Thu, 18 Dec 2014 11:06:40 +0000
Message-ID: <CO1PR06MB078DB45B606C923F712A57BD16A0@CO1PR06MB078.namprd06.prod.outlook.com>
References: <1418896856-15766-1-git-send-email-dudl@cypress.com>
In-Reply-To: <1418896856-15766-1-git-send-email-dudl@cypress.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR06MB078;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR06MB078;
x-forefront-prvs: 042957ACD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(13464003)(199003)(189002)(51164003)(164054003)(77156002)(76576001)(62966003)(97736003)(92566001)(66066001)(101416001)(31966008)(102836002)(19580395003)(19580405001)(86362001)(2201001)(2900100001)(68736005)(106356001)(20776003)(4396001)(120916001)(2501002)(21056001)(54356999)(54606007)(64706001)(46102003)(50986999)(33656002)(106116001)(2656002)(122556002)(107046002)(87936001)(2950100001)(99286002)(54206007)(105586002)(76176999)(40100003)(74316001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR06MB078;H:CO1PR06MB078.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremiah,

I re-sent the v16 patches through the new internal email server with my emal dudl@cypress.com.
Could you help check if all patches were fine and not broken.

Thanks,
Dudley

> -----Original Message-----
> From: Dudley Du [mailto:dudl@cypress.com]
> Sent: 2014?12?18? 18:01
> To: dmitry.torokhov@gmail.com; jmmahler@gmail.com; rydberg@euromail.se
> Cc: Dudley Du; bleung@google.com; David Solda; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
>
> V16 patches have below updates, details of other updates see history list:
> 1) Fix all miss-spelling and space issue.
> 2) Rename variables and functions with much more clearer names.
> 3) Initialize and document tries near where it will be used.
> 4) Modify cmd buffer to struct for more descriptive way.
>
>
> This patch series is aimed to re-design the cyapa driver to support
> old gen3 trackpad devices and new gen5 trackpad devices in one
> cyapa driver, it's for easily productions support based on
> customers' requirements. And add sysfs functions and interfaces
> supported that required by users and customers.
>
> Since the earlier gen3 and the latest gen5 trackpad devices using
> two different chipsets, and have different protocols and interfaces,
> so if supported these two type trackpad devices in two different drivers,
> then it will be difficult to manage productions and later firmware updates.
> e.g.: It will cause customer don't know which one trackpad device firmware
> image to use and update when it has been used and integrated
> in same one productions, so here we support these two trackpad
> devices in same on driver.
>
>
> Dudley Du (12):
>   input: cyapa: re-design driver to support multi-trackpad in one driver
>   input: cyapa: add gen5 trackpad device basic functions support
>   input: cyapa: add power management interfaces support for the device
>   input: cyapa: add runtime power management interfaces support for the
>     device
>   input: cyapa: add sysfs interfaces support in the cyapa driver
>   input: cyapa: add gen3 trackpad device firmware update function
>     support
>   input: cyapa: add gen3 trackpad device read baseline function support
>   input: cyapa: add gen3 trackpad device force re-calibrate function
>     support
>   input: cyapa: add gen5 trackpad device firmware update function
>     support
>   input: cyapa: add gen5 trackpad device read baseline function support
>   input: cyapa: add gen5 trackpad device force re-calibrate function
>     support
>   input: cyapa: add acpi device id support
>
>  drivers/input/mouse/Kconfig      |    1 +
>  drivers/input/mouse/Makefile     |    3 +-
>  drivers/input/mouse/cyapa.c      | 1692 ++++++++++++++---------
>  drivers/input/mouse/cyapa.h      |  314 +++++
>  drivers/input/mouse/cyapa_gen3.c | 1220 +++++++++++++++++
>  drivers/input/mouse/cyapa_gen5.c | 2767
> ++++++++++++++++++++++++++++++++++++++
>  6 files changed, 5325 insertions(+), 672 deletions(-)
>  create mode 100644 drivers/input/mouse/cyapa.h
>  create mode 100644 drivers/input/mouse/cyapa_gen3.c
>  create mode 100644 drivers/input/mouse/cyapa_gen5.c
>
>
> History patch series modifications list:
> V15 patches have below main updates compared with v14 patches:
> 1) Fix all warning errors of sparse tool when running with "make C=1".
> 2) Change variable name "unique_str" to "product_id" for clearer meanings.
> 3) Update cyapa_i2c_write function to return error directly when length > 31.
>
> V14 patches have below main updates compared with v13 patches:
> 1) Correct 9 miss spelling issues of "bufferred" to "buffered".
> 2) Fix the upgrade issue of removing MOUSE_CYAPA config when make oldconfig
>    by replase "depends on I2C && CRC_ITU_T" with
> "depends on I2C"
> "select CRC_ITU_T"
>    in patch 9.
>
> V13 patches have below main updates compared with v12 patches:
> 1) Remove all debugfs interface, including read_fw and raw_data interfaces.
> 2) This patches are made based linux next-20141208.
>
> V12 patches have below main updates compared with v11 patches:
> 1) Add check that when TP is detected but not operational, do not exit driver
>    immediately, but wait and export the update_fw interface for recovering.
> 2) Re-arrange the function codes, remove unnesseary protype definitions in
>    the header file.
>
> V11 patches have below main updates compared with v10 patches:
> 1) Add add acpi device id supported for old gen3 and new gen5 trackpad devices.
> 2) Fix the unable to update firmware issue when cyapa_open is not called
>    which means the irq for firwmare update process is not enabled. This fix
>    by checking if the irq is enabled, if not then enable irq before start to
>    do firmware update.
>
> V10 patches have below main updates compared with v9 patches:
> 1) Modify code to following kernel code style.
>    e.g.: correct to use error as return name when there is only error path,
>    and fix the checkpatch.sh wanting in the driver.
> 2) Remove cyapa_remove method and use input open and close interface to
>    following device resouse management infrastructure.
> 3) Modify cyapa_detect method to return tristate issue to make the return value
>    much more consistent and clear.
> 4) Use platform supplied functions as possible instead of driver
>    specific rewritten version.
>
> V9 patches have below updates compared with v8 patches:
> 1) Removed all async thread stuff from the driver.
> 2) Split driver into 18 patches for each function change one patch.
>
> V8 patches have below updates compared with v7 patches:
> 1) [PATCH v8 01/13] - Remove the async thread for device detect in
>    probe routine, now the device detect process is completely done within
>    the device probe routine.
> 2) [PATCH v8 01/13] - Split the irq cmd hander function to separated
>    function cyapa_default_irq_cmd_handler() and set it to interface
>    cyapa_default_ops.irq_cmd_handler.
> 3) [PATCH v8 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
>    to avoid miss-enter when device protocol is still in detecting.
>
> V7 patches have below updates compared with v6 patches:
> 1) [PATCH v7 01/13] - Split the irq cmd hander function to separated
>    function cyapa_default_irq_cmd_handler() and set it to interface
>    cyapa_default_ops.irq_cmd_handler.
> 2) [PATCH v7 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
>    to avoid miss-enter when device protocol is still in detecting.
>
>
> V6 patches have below updates compared with v5 patches:
> 1) Remove patch 14 of the lid filtering from the cyapa driver.
>
> V5 patches have below updates compared with v4 patches:
> 1) Uses get_device()/put_device() instead of kobject_get()/kobject_put();
> 2) Fix memories freed before debugfs entries issue;
> 3) Make cyapa_debugs_root valid in driver module level
>    in module_init()/moudle_exit() ;
> 4) Fix i2c_transfer() may return partial transfer issues.
> 5) Add cyapa->removed flag to avoid detecting thread may still running
>    when driver module is removed.
> 6) Fix the meanings of some comments and return error code not clear issue.

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
