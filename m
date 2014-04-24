Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaDXFb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:31:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26344 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaDXFbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:31:23 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-e8-5358a1a9ae35
Message-id: <5358A1B1.8090000@samsung.com>
Date: Thu, 24 Apr 2014 14:31:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: balbi@ti.com
Cc: Chanwoo Choi <cwchoi00@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: extcon-next regression ?
References: <20140423164033.GR9593@saruman.home>
 <20140423172051.GS9593@saruman.home>
In-reply-to: <20140423172051.GS9593@saruman.home>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkQHflwohgg6nfbCwO3q+3eHZU2+LC
	0x42i8u75rBZzF7Sz2Kx/4qXA5vHt6+TWDx2zrrL7nH8xnYmj8+b5AJYorhsUlJzMstSi/Tt
	Ergyjqw/y1SwqJWpoun1EuYGxle3GLsYOTkkBEwk1j75AmWLSVy4t56ti5GLQ0hgKaPEzP0T
	WWCKdq2axQSRWMQoMeP/anYI5zWjxKz3rcwgVbwCWhIXXy9iBbFZBFQljq++C2azAcX3v7jB
	BmKLCoRJrJx+hQWiXlDix+R7YLaIgIDE+heXwIYyCzxllLg09zvQUA4OYaBBR/86gJhCAuES
	szbagJRzChhK7Fv2CWwks4COxP7WaVC2vMTmNW+ZIY4+xC6x5mMNxDkCEt8mH2IBGSMhICux
	6QBUiaTEwRU3WCYwis1CctAsJFNnIZm6gJF5FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZg
	fJ3+92zCDsZ7B6wPMSYDrZzILCWanA+Mz7ySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYExcbRmtcXze96JtHLXHbMWd/d/xTjLbcIYjMs28Mt3g
	oN/vCHeGS6lrfRrFXd7fygn4cdpo19+DV50fvuF9trjUP01os4KhJfeUbAOziiP6v5sSle2S
	/q+PzNvbO6/Y6Pg2Zt1DKxlf/Z6Yu69S8c3U6R27b3dwyTz7lNlnvXLHh8Lv09Y3H1diKc5I
	NNRiLipOBACvo92GxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAd2VCyOCDbZv0rU4eL/e4tlRbYsL
	T3vYLC7vmsNmMXtJP4vF/iteDmwe375OYvHYOesuu8fxG9uZPD5vkgtgiWpgtMlITUxJLVJI
	zUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWq2kUJaYUwoUCkgsLlbS
	t8M0ITTETdcCpjFC1zckCK7HyAANJKxhzDiy/ixTwaJWpoqm10uYGxhf3WLsYuTkkBAwkdi1
	ahYThC0mceHeerYuRi4OIYFFjBIz/q9mh3BeM0rMet/KDFLFK6AlcfH1IlYQm0VAVeL46rtg
	NhtQfP+LG2wgtqhAmMTK6VdYIOoFJX5MvgdmiwgISKx/cQlsKLPAU0aJS3O/Aw3l4BAGGnT0
	rwOIKSQQLjFrow1IOaeAocS+ZZ/ARjIL6Ejsb50GZctLbF7zlnkCo8AsJBtmISmbhaRsASPz
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg+H0mvYNxVYPFIUYBDkYlHl6FW+HBQqyJZcWV
	uYcYJTiYlUR418yNCBbiTUmsrEotyo8vKs1JLT7EmAwMgInMUqLJ+cDUklcSb2hsYmZkaWRu
	aGFkbE6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjEFS8vzSk96tvOx553LjKVe7T0oZ
	P/7U7dt0KmvBg0mc+tISxae22MQ2nVFqnv3su/Ljibt09x5zvMo8lfVGn1PSzp/y8Q4aN7uO
	/Ch++unTWonat7HaGbOk5t7/YNHNOIGFaz7rzgw3o6dvOYzPSay6mc1cILVHhefC1LXrcp/F
	/G1qYvM32KzEUpyRaKjFXFScCABPUAQnIwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Thanks for your test and review.

On 04/24/2014 02:20 AM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Apr 23, 2014 at 11:40:33AM -0500, Felipe Balbi wrote:
>> Hi Chanwoo,
>>
>> I've been testing extcon-next to make sure USB3 on OMAP5 will work out
>> of the box but I see a regression when I merge your tree on top of
>> v3.15-rc2 + Tony's DT fixes.
>>
>> Here's what I see (trimmed):
>>
>> [    1.805870] palmas 0-0048: Muxing GPIO 2, PWM 0, LED 0
>> [    1.812516] ------------[ cut here ]------------
>> [    1.817387] WARNING: CPU: 0 PID: 6 at include/linux/kref.h:47 kobject_get+0x64/0x78()
>> [    1.817691]  mmcblk0boot1: unknown partition table
>> [    1.830601] Modules linked in:
>> [    1.833827] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3.15.0-rc2-00041-g3019b77 #308
>> [    1.843333] Workqueue: deferwq deferred_probe_work_func
>> [    1.848728]  mmcblk0boot0: unknown partition table
>> [    1.853928] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_stack+0x10/0x14)
>> [    1.862086] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x84/0x9c)
>> [    1.869667] [<c05426b4>] (dump_stack) from [<c0040928>] (warn_slowpath_common+0x6c/0x90)
>> [    1.878181] [<c0040928>] (warn_slowpath_common) from [<c00409e8>] (warn_slowpath_null+0x1c/0x24)
>> [    1.887421] [<c00409e8>] (warn_slowpath_null) from [<c02d50c4>] (kobject_get+0x64/0x78)
>> [    1.895837] [<c02d50c4>] (kobject_get) from [<c0350188>] (device_add+0x18/0x520)
>> [    1.903629] [<c0350188>] (device_add) from [<c0462a5c>] (extcon_dev_register+0x48/0x104)
>> [    1.912145] [<c0462a5c>] (extcon_dev_register) from [<c0462b44>] (devm_extcon_dev_register+0x2c/0x68)
>> [    1.921847] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] (palmas_usb_probe+0x110/0x304)
>> [    1.931453] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platform_drv_probe+0x18/0x48)
>> [    1.940333] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    1.949664] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    1.958634] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    1.967003] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    1.975387] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_add+0x420/0x520)
>> [    1.983678] [<c0350590>] (device_add) from [<c045a310>] (of_platform_device_create_pdata+0x6c/0x8c)
>> [    1.993155] [<c045a310>] (of_platform_device_create_pdata) from [<c045a418>] (of_platform_bus_create+0xdc/0x168)
>> [    2.003818] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (of_platform_populate+0x5c/0xa0)
>> [    2.013399] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (palmas_i2c_probe+0x30c/0x584)
>> [    2.022606] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    2.031722] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    2.040715] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    2.049098] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    2.057482] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_add+0x420/0x520)
>> [    2.065774] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_device+0x12c/0x18c)
>> [    2.073885] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_register_adapter+0x278/0x498)
>> [    2.082903] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (omap_i2c_probe+0x4a4/0x6d0)
>> [    2.091925] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_drv_probe+0x18/0x48)
>> [    2.100582] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    2.109883] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    2.118823] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    2.127194] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    2.135584] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferred_probe_work_func+0x64/0x94)
>> [    2.144975] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] (process_one_work+0x1ac/0x4cc)
>> [    2.154545] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_thread+0x114/0x3b4)
>> [    2.163119] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0xd4/0xf0)
>> [    2.170695] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x14/0x2c)
>> [    2.178259] ---[ end trace 3006de6450234d28 ]---
>> [    2.183081] kobject 'palmas_usb' (eca58c38): tried to add an uninitialized object, something is seriously wrong.
>> [    2.193731] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3.15.0-rc2-00041-g3019b77 #308
>> [    2.203201] Workqueue: deferwq deferred_probe_work_func
>> [    2.208687] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_stack+0x10/0x14)
>> [    2.216789] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x84/0x9c)
>> [    2.224357] [<c05426b4>] (dump_stack) from [<c02d5c28>] (kobject_add+0x88/0x98)
>> [    2.232014] [<c02d5c28>] (kobject_add) from [<c0350250>] (device_add+0xe0/0x520)
>> [    2.239758] [<c0350250>] (device_add) from [<c0462a5c>] (extcon_dev_register+0x48/0x104)
>> [    2.248235] [<c0462a5c>] (extcon_dev_register) from [<c0462b44>] (devm_extcon_dev_register+0x2c/0x68)
>> [    2.257901] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] (palmas_usb_probe+0x110/0x304)
>> [    2.267467] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platform_drv_probe+0x18/0x48)
>> [    2.276298] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    2.285591] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    2.294520] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    2.302905] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    2.311286] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_add+0x420/0x520)
>> [    2.319583] [<c0350590>] (device_add) from [<c045a310>] (of_platform_device_create_pdata+0x6c/0x8c)
>> [    2.329063] [<c045a310>] (of_platform_device_create_pdata) from [<c045a418>] (of_platform_bus_create+0xdc/0x168)
>> [    2.339725] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (of_platform_populate+0x5c/0xa0)
>> [    2.349296] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (palmas_i2c_probe+0x30c/0x584)
>> [    2.358496] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    2.367609] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    2.376523] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    2.384914] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    2.393301] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_add+0x420/0x520)
>> [    2.401601] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_device+0x12c/0x18c)
>> [    2.409707] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_register_adapter+0x278/0x498)
>> [    2.418727] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (omap_i2c_probe+0x4a4/0x6d0)
>> [    2.427741] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_drv_probe+0x18/0x48)
>> [    2.436382] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    2.445680] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    2.454613] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    2.463001] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    2.471385] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferred_probe_work_func+0x64/0x94)
>> [    2.480772] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] (process_one_work+0x1ac/0x4cc)
>> [    2.490339] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_thread+0x114/0x3b4)
>> [    2.498906] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0xd4/0xf0)
>> [    2.506460] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x14/0x2c)
>> [    2.514023] ------------[ cut here ]------------
>> [    2.518870] WARNING: CPU: 0 PID: 6 at lib/kobject.c:670 kobject_put+0x80/0x90()
>> [    2.526514] kobject: 'palmas_usb' (eca58c38): is not initialized, yet kobject_put() is being called.
>> [    2.536076] Modules linked in:
>> [    2.539287] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3.15.0-rc2-00041-g3019b77 #308
>> [    2.548753] Workqueue: deferwq deferred_probe_work_func
>> [    2.554223] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_stack+0x10/0x14)
>> [    2.562341] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x84/0x9c)
>> [    2.569911] [<c05426b4>] (dump_stack) from [<c0040928>] (warn_slowpath_common+0x6c/0x90)
>> [    2.578391] [<c0040928>] (warn_slowpath_common) from [<c004097c>] (warn_slowpath_fmt+0x30/0x40)
>> [    2.587502] [<c004097c>] (warn_slowpath_fmt) from [<c02d5158>] (kobject_put+0x80/0x90)
>> [    2.595780] [<c02d5158>] (kobject_put) from [<c03502fc>] (device_add+0x18c/0x520)
>> [    2.603623] [<c03502fc>] (device_add) from [<c0462a5c>] (extcon_dev_register+0x48/0x104)
>> [    2.612103] [<c0462a5c>] (extcon_dev_register) from [<c0462b44>] (devm_extcon_dev_register+0x2c/0x68)
>> [    2.621762] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] (palmas_usb_probe+0x110/0x304)
>> [    2.631321] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platform_drv_probe+0x18/0x48)
>> [    2.640161] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    2.649447] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    2.658386] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    2.666757] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    2.675144] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_add+0x420/0x520)
>> [    2.683441] [<c0350590>] (device_add) from [<c045a310>] (of_platform_device_create_pdata+0x6c/0x8c)
>> [    2.692921] [<c045a310>] (of_platform_device_create_pdata) from [<c045a418>] (of_platform_bus_create+0xdc/0x168)
>> [    2.703575] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (of_platform_populate+0x5c/0xa0)
>> [    2.713139] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (palmas_i2c_probe+0x30c/0x584)
>> [    2.722341] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    2.731457] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    2.740380] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    2.748764] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    2.757135] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_add+0x420/0x520)
>> [    2.765429] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_device+0x12c/0x18c)
>> [    2.773549] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_register_adapter+0x278/0x498)
>> [    2.782576] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (omap_i2c_probe+0x4a4/0x6d0)
>> [    2.791597] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_drv_probe+0x18/0x48)
>> [    2.800261] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    2.809560] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    2.818489] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    2.826865] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    2.835253] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferred_probe_work_func+0x64/0x94)
>> [    2.844637] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] (process_one_work+0x1ac/0x4cc)
>> [    2.854205] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_thread+0x114/0x3b4)
>> [    2.862778] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0xd4/0xf0)
>> [    2.870349] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x14/0x2c)
>> [    2.877911] ---[ end trace 3006de6450234d29 ]---
>> [    2.882734] ------------[ cut here ]------------
>> [    2.887573] WARNING: CPU: 0 PID: 6 at lib/kobject.c:670 kobject_put+0x80/0x90()
>> [    2.895209] kobject: 'palmas_usb' (eca58c38): is not initialized, yet kobject_put() is being called.
>> [    2.904765] Modules linked in:
>> [    2.907971] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: G        W     3.15.0-rc2-00041-g3019b77 #308
>> [    2.917447] Workqueue: deferwq deferred_probe_work_func
>> [    2.922924] [<c0015110>] (unwind_backtrace) from [<c0011d6c>] (show_stack+0x10/0x14)
>> [    2.931033] [<c0011d6c>] (show_stack) from [<c05426b4>] (dump_stack+0x84/0x9c)
>> [    2.938606] [<c05426b4>] (dump_stack) from [<c0040928>] (warn_slowpath_common+0x6c/0x90)
>> [    2.947069] [<c0040928>] (warn_slowpath_common) from [<c004097c>] (warn_slowpath_fmt+0x30/0x40)
>> [    2.956187] [<c004097c>] (warn_slowpath_fmt) from [<c02d5158>] (kobject_put+0x80/0x90)
>> [    2.964483] [<c02d5158>] (kobject_put) from [<c0462abc>] (extcon_dev_register+0xa8/0x104)
>> [    2.973053] [<c0462abc>] (extcon_dev_register) from [<c0462b44>] (devm_extcon_dev_register+0x2c/0x68)
>> [    2.982718] [<c0462b44>] (devm_extcon_dev_register) from [<c04630c0>] (palmas_usb_probe+0x110/0x304)
>> [    2.992285] [<c04630c0>] (palmas_usb_probe) from [<c0354284>] (platform_drv_probe+0x18/0x48)
>> [    3.001124] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    3.010423] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    3.019358] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    3.027746] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    3.036121] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_add+0x420/0x520)
>> [    3.044418] [<c0350590>] (device_add) from [<c045a310>] (of_platform_device_create_pdata+0x6c/0x8c)
>> [    3.053893] [<c045a310>] (of_platform_device_create_pdata) from [<c045a418>] (of_platform_bus_create+0xdc/0x168)
>> [    3.064550] [<c045a418>] (of_platform_bus_create) from [<c045a5cc>] (of_platform_populate+0x5c/0xa0)
>> [    3.074124] [<c045a5cc>] (of_platform_populate) from [<c0373c78>] (palmas_i2c_probe+0x30c/0x584)
>> [    3.083338] [<c0373c78>] (palmas_i2c_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    3.092447] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    3.101381] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    3.109767] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    3.118147] [<c035206c>] (bus_probe_device) from [<c0350590>] (device_add+0x420/0x520)
>> [    3.126432] [<c0350590>] (device_add) from [<c0424020>] (i2c_new_device+0x12c/0x18c)
>> [    3.134547] [<c0424020>] (i2c_new_device) from [<c0424980>] (i2c_register_adapter+0x278/0x498)
>> [    3.143569] [<c0424980>] (i2c_register_adapter) from [<c04275c0>] (omap_i2c_probe+0x4a4/0x6d0)
>> [    3.152593] [<c04275c0>] (omap_i2c_probe) from [<c0354284>] (platform_drv_probe+0x18/0x48)
>> [    3.161249] [<c0354284>] (platform_drv_probe) from [<c0352b0c>] (driver_probe_device+0x110/0x22c)
>> [    3.170537] [<c0352b0c>] (driver_probe_device) from [<c03511a0>] (bus_for_each_drv+0x58/0x8c)
>> [    3.179472] [<c03511a0>] (bus_for_each_drv) from [<c03529c8>] (device_attach+0x74/0x8c)
>> [    3.187854] [<c03529c8>] (device_attach) from [<c035206c>] (bus_probe_device+0x88/0xb0)
>> [    3.196222] [<c035206c>] (bus_probe_device) from [<c03524ac>] (deferred_probe_work_func+0x64/0x94)
>> [    3.205611] [<c03524ac>] (deferred_probe_work_func) from [<c0058c70>] (process_one_work+0x1ac/0x4cc)
>> [    3.215174] [<c0058c70>] (process_one_work) from [<c0059b10>] (worker_thread+0x114/0x3b4)
>> [    3.223739] [<c0059b10>] (worker_thread) from [<c005f6f0>] (kthread+0xd4/0xf0)
>> [    3.231313] [<c005f6f0>] (kthread) from [<c000e3c8>] (ret_from_fork+0x14/0x2c)
>> [    3.238883] ---[ end trace 3006de6450234d2a ]---
>> [    3.243711] palmas-usb palmas_usb.7: failed to register extcon device
>> [    3.250493] palmas-usb: probe of palmas_usb.7 failed with error -22
>>
>> Any ideas ??
> 
> bisected down to:
> 
> commit 854b85057cc6b90a326b731174b6c6dbbf34222a
> Author: Chanwoo Choi <cw00.choi@samsung.com>
> Date:   Mon Apr 21 19:46:51 2014 +0900
> 
>     extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
>     
>     This patch add APIs to control the extcon device on extcon provider driver.
>     The extcon_dev_allocate() allocates the memory of extcon device and initializes
>     supported cables. And then extcon_dev_free() decrement the reference of the
>     device of extcon device and free the memory of the extcon device. This APIs
>     must need to implement devm_extcon_dev_allocate()/free() APIs.
>     
>     Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index f6df689..3e485bc 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -558,6 +558,9 @@ static int create_extcon_class(void)
>  
>  static void extcon_dev_release(struct device *dev)
>  {
> +	struct extcon_dev *edev = dev_to_extcon_dev(dev);
> +
> +	kfree(edev);
>  }
>  
>  static const char *muex_name = "mutually_exclusive";
> @@ -576,7 +579,7 @@ static void dummy_sysfs_dev_release(struct device *dev)
>   */
>  int extcon_dev_register(struct extcon_dev *edev)
>  {
> -	int ret, index = 0;
> +	int ret;
>  
>  	if (!extcon_class) {
>  		ret = create_extcon_class();
> @@ -584,80 +587,150 @@ int extcon_dev_register(struct extcon_dev *edev)
>  			return ret;
>  	}
>  
> -	if (edev->supported_cable) {
> -		/* Get size of array */
> -		for (index = 0; edev->supported_cable[index]; index++)
> -			;
> -		edev->max_supported = index;
> -	} else {
> -		edev->max_supported = 0;
> +	edev->name = edev->name ? edev->name : dev_name(edev->dev.parent);
> +	if (IS_ERR_OR_NULL(edev->name)) {
> +		dev_err(&edev->dev, "extcon device name is null\n");
> +		return -EINVAL;
>  	}
> +	dev_set_name(&edev->dev, "%s", edev->name);
>  
> -	if (index > SUPPORTED_CABLE_MAX) {
> -		dev_err(&edev->dev, "extcon: maximum number of supported cables exceeded.\n");
> -		return -EINVAL;
> +	ret = device_add(&edev->dev);
> +	if (ret) {
> +		put_device(&edev->dev);
> +		return ret;
>  	}
> +#if defined(CONFIG_ANDROID)
> +	if (switch_class)
> +		ret = class_compat_create_link(switch_class, &edev->dev, NULL);
> +#endif /* CONFIG_ANDROID */
>  
> -	edev->dev.class = extcon_class;
> -	edev->dev.release = extcon_dev_release;
> +	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
>  
> -	edev->name = edev->name ? edev->name : dev_name(edev->dev.parent);
> -	if (IS_ERR_OR_NULL(edev->name)) {
> -		dev_err(&edev->dev,
> -			"extcon device name is null\n");
> -		return -EINVAL;
> +	dev_set_drvdata(&edev->dev, edev);
> +	edev->state = 0;
> +
> +	mutex_lock(&extcon_dev_list_lock);
> +	list_add(&edev->entry, &extcon_dev_list);
> +	mutex_unlock(&extcon_dev_list_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(extcon_dev_register);
> +
> +/**
> + * extcon_dev_unregister() - Unregister the extcon device.
> + * @edev:	the extcon device instance to be unregistered.
> + */
> +void extcon_dev_unregister(struct extcon_dev *edev)
> +{
> +	mutex_lock(&extcon_dev_list_lock);
> +	list_del(&edev->entry);
> +	mutex_unlock(&extcon_dev_list_lock);
> +
> +	if (IS_ERR_OR_NULL(get_device(&edev->dev))) {
> +		dev_err(&edev->dev, "Failed to unregister extcon_dev (%s)\n",
> +				dev_name(&edev->dev));
> +		return;
>  	}
> -	dev_set_name(&edev->dev, "%s", edev->name);
>  
> -	if (edev->max_supported) {
> -		char buf[10];
> -		char *str;
> -		struct extcon_cable *cable;
> +	device_unregister(&edev->dev);
>  
> -		edev->cables = kzalloc(sizeof(struct extcon_cable) *
> -				       edev->max_supported, GFP_KERNEL);
> -		if (!edev->cables) {
> +#if defined(CONFIG_ANDROID)
> +	if (switch_class)
> +		class_compat_remove_link(switch_class, &edev->dev, NULL);
> +#endif
> +}
> +EXPORT_SYMBOL_GPL(extcon_dev_unregister);
> +
> +/*
> + * extcon_dev_allocate() - Allocate the memory of extcon device.
> + * @supported_cable:	Array of supported cable names ending with NULL.
> + *			If supported_cable is NULL, cable name related APIs
> + *			are disabled.
> + *
> + * This function allocates the memory for extcon device without allocating
> + * memory in each extcon provider driver and initialize default setting for
> + * extcon device.
> + *
> + * Return the pointer of extcon device if success or ERR_PTR(err) if fail
> + */
> +struct extcon_dev *extcon_dev_allocate(const char **supported_cable)
> +{
> +	struct extcon_dev *edev;
> +	int index, ret, count = 0;
> +
> +	edev = kzalloc(sizeof(*edev), GFP_KERNEL);
> +	if (!edev) {
> +		pr_err("Failed to allocate the memory for extcon device\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	edev->max_supported = 0;
> +	edev->supported_cable = supported_cable;
> +	if (edev->supported_cable) {
> +		for (count = 0; edev->supported_cable[count]; count++)
> +			;
> +		edev->max_supported = count;
> +		if (count > SUPPORTED_CABLE_MAX) {
> +			pr_err("Exceed max number of supported cables\n");
>  			ret = -ENOMEM;
> -			goto err_sysfs_alloc;
> +			goto err;
>  		}
> -		for (index = 0; index < edev->max_supported; index++) {
> -			cable = &edev->cables[index];
> +	}
>  
> -			snprintf(buf, 10, "cable.%d", index);
> -			str = kzalloc(sizeof(char) * (strlen(buf) + 1),
> -				      GFP_KERNEL);
> -			if (!str) {
> -				for (index--; index >= 0; index--) {
> -					cable = &edev->cables[index];
> -					kfree(cable->attr_g.name);
> -				}
> -				ret = -ENOMEM;
> +	edev->dev.class = extcon_class;
> +	edev->dev.release = extcon_dev_release;
> +	device_initialize(&edev->dev);
> +	spin_lock_init(&edev->lock);
> +
> +	if (!edev->max_supported)
> +		return 0;
> +
> +	edev->cables = kzalloc(sizeof(struct extcon_cable) *
> +			       edev->max_supported, GFP_KERNEL);
> +	if (!edev->cables) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
>  
> -				goto err_alloc_cables;
> +	for (index = 0; index < edev->max_supported; index++) {
> +		struct extcon_cable *cable = &edev->cables[index];
> +		char buf[10];
> +		char *str;
> +
> +		snprintf(buf, 10, "cable.%d", index);
> +		str = kzalloc(sizeof(char) * (strlen(buf) + 1),
> +			      GFP_KERNEL);
> +		if (!str) {
> +			for (index--; index >= 0; index--) {
> +				cable = &edev->cables[index];
> +				kfree(cable->attr_g.name);
>  			}
> -			strcpy(str, buf);
> -
> -			cable->edev = edev;
> -			cable->cable_index = index;
> -			cable->attrs[0] = &cable->attr_name.attr;
> -			cable->attrs[1] = &cable->attr_state.attr;
> -			cable->attrs[2] = NULL;
> -			cable->attr_g.name = str;
> -			cable->attr_g.attrs = cable->attrs;
> -
> -			sysfs_attr_init(&cable->attr_name.attr);
> -			cable->attr_name.attr.name = "name";
> -			cable->attr_name.attr.mode = 0444;
> -			cable->attr_name.show = cable_name_show;
> -
> -			sysfs_attr_init(&cable->attr_state.attr);
> -			cable->attr_state.attr.name = "state";
> -			cable->attr_state.attr.mode = 0444;
> -			cable->attr_state.show = cable_state_show;
> +			ret = -ENOMEM;
> +			goto err_alloc_cables;
>  		}
> +		strcpy(str, buf);
> +
> +		cable->edev = edev;
> +		cable->cable_index = index;
> +		cable->attrs[0] = &cable->attr_name.attr;
> +		cable->attrs[1] = &cable->attr_state.attr;
> +		cable->attrs[2] = NULL;
> +		cable->attr_g.name = str;
> +		cable->attr_g.attrs = cable->attrs;
> +
> +		sysfs_attr_init(&cable->attr_name.attr);
> +		cable->attr_name.attr.name = "name";
> +		cable->attr_name.attr.mode = 0444;
> +		cable->attr_name.show = cable_name_show;
> +
> +		sysfs_attr_init(&cable->attr_state.attr);
> +		cable->attr_state.attr.name = "state";
> +		cable->attr_state.attr.mode = 0444;
> +		cable->attr_state.show = cable_state_show;
>  	}
>  
> -	if (edev->max_supported && edev->mutually_exclusive) {
> +	if (edev->mutually_exclusive) {
>  		char buf[80];
>  		char *name;
>  
> @@ -703,59 +776,32 @@ int extcon_dev_register(struct extcon_dev *edev)
>  		}
>  		edev->attr_g_muex.name = muex_name;
>  		edev->attr_g_muex.attrs = edev->attrs_muex;
> -
>  	}
>  
> -	if (edev->max_supported) {
> -		edev->extcon_dev_type.groups =
> -			kzalloc(sizeof(struct attribute_group *) *
> -				(edev->max_supported + 2), GFP_KERNEL);
> -		if (!edev->extcon_dev_type.groups) {
> -			ret = -ENOMEM;
> -			goto err_alloc_groups;
> -		}
> -
> -		edev->extcon_dev_type.name = dev_name(&edev->dev);
> -		edev->extcon_dev_type.release = dummy_sysfs_dev_release;
> -
> -		for (index = 0; index < edev->max_supported; index++)
> -			edev->extcon_dev_type.groups[index] =
> -				&edev->cables[index].attr_g;
> -		if (edev->mutually_exclusive)
> -			edev->extcon_dev_type.groups[index] =
> -				&edev->attr_g_muex;
> -
> -		edev->dev.type = &edev->extcon_dev_type;
> +	edev->extcon_dev_type.groups =
> +		kzalloc(sizeof(struct attribute_group *) *
> +			(edev->max_supported + 2), GFP_KERNEL);
> +	if (!edev->extcon_dev_type.groups) {
> +		ret = -ENOMEM;
> +		goto err_alloc_groups;
>  	}
>  
> -	ret = device_register(&edev->dev);
> -	if (ret) {
> -		put_device(&edev->dev);
> -		goto err_dev;
> -	}
> -#if defined(CONFIG_ANDROID)
> -	if (switch_class)
> -		ret = class_compat_create_link(switch_class, &edev->dev, NULL);
> -#endif /* CONFIG_ANDROID */
> -
> -	spin_lock_init(&edev->lock);
> -
> -	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
> +	edev->extcon_dev_type.name = dev_name(&edev->dev);
> +	edev->extcon_dev_type.release = dummy_sysfs_dev_release;
>  
> -	dev_set_drvdata(&edev->dev, edev);
> -	edev->state = 0;
> +	for (index = 0; index < edev->max_supported; index++)
> +		edev->extcon_dev_type.groups[index] =
> +			&edev->cables[index].attr_g;
> +	if (edev->mutually_exclusive)
> +		edev->extcon_dev_type.groups[index] =
> +			&edev->attr_g_muex;
>  
> -	mutex_lock(&extcon_dev_list_lock);
> -	list_add(&edev->entry, &extcon_dev_list);
> -	mutex_unlock(&extcon_dev_list_lock);
> +	edev->dev.type = &edev->extcon_dev_type;
>  
> -	return 0;
> +	return edev;
>  
> -err_dev:
> -	if (edev->max_supported)
> -		kfree(edev->extcon_dev_type.groups);
>  err_alloc_groups:
> -	if (edev->max_supported && edev->mutually_exclusive) {
> +	if (edev->mutually_exclusive) {
>  		for (index = 0; edev->mutually_exclusive[index]; index++)
>  			kfree(edev->d_attrs_muex[index].attr.name);
>  		kfree(edev->d_attrs_muex);
> @@ -765,36 +811,22 @@ err_muex:
>  	for (index = 0; index < edev->max_supported; index++)
>  		kfree(edev->cables[index].attr_g.name);
>  err_alloc_cables:
> -	if (edev->max_supported)
> -		kfree(edev->cables);
> -err_sysfs_alloc:
> -	return ret;
> +	kfree(edev->cables);
> +err:
> +	kfree(edev);
> +
> +	return ERR_PTR(ret);
>  }
> -EXPORT_SYMBOL_GPL(extcon_dev_register);
> +EXPORT_SYMBOL_GPL(extcon_dev_allocate);
>  
> -/**
> - * extcon_dev_unregister() - Unregister the extcon device.
> - * @edev:	the extcon device instance to be unregistered.
> - *
> - * Note that this does not call kfree(edev) because edev was not allocated
> - * by this class.
> +/*
> + * extcon_dev_free() - Free the memory of extcon device.
> + * @edev:	the extcon device to free
>   */
> -void extcon_dev_unregister(struct extcon_dev *edev)
> +void extcon_dev_free(struct extcon_dev *edev)
>  {
>  	int index;
>  
> -	mutex_lock(&extcon_dev_list_lock);
> -	list_del(&edev->entry);
> -	mutex_unlock(&extcon_dev_list_lock);
> -
> -	if (IS_ERR_OR_NULL(get_device(&edev->dev))) {
> -		dev_err(&edev->dev, "Failed to unregister extcon_dev (%s)\n",
> -				dev_name(&edev->dev));
> -		return;
> -	}
> -
> -	device_unregister(&edev->dev);
> -
>  	if (edev->mutually_exclusive && edev->max_supported) {
>  		for (index = 0; edev->mutually_exclusive[index];
>  				index++)
> @@ -811,13 +843,10 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  		kfree(edev->cables);
>  	}
>  
> -#if defined(CONFIG_ANDROID)
> -	if (switch_class)
> -		class_compat_remove_link(switch_class, &edev->dev, NULL);
> -#endif
> -	put_device(&edev->dev);
> +	if (edev)
> +		put_device(&edev->dev);
>  }
> -EXPORT_SYMBOL_GPL(extcon_dev_unregister);
> +EXPORT_SYMBOL_GPL(extcon_dev_free);
>  
>  static void devm_extcon_dev_unreg(struct device *dev, void *res)
>  {
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index 85a8a5b..20587ee 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -179,6 +179,8 @@ struct extcon_specific_cable_nb {
>  
>  #if IS_ENABLED(CONFIG_EXTCON)
>  
> +#define dev_to_extcon_dev(d) container_of(d, struct extcon_dev, dev)
> +
>  /*
>   * Following APIs are for notifiers or configurations.
>   * Notifiers are the external port and connection devices.
> @@ -250,6 +252,12 @@ extern int extcon_unregister_notifier(struct extcon_dev *edev,
>  				      struct notifier_block *nb);
>  
>  /*
> + * Following APIs control the memory of extcon device.
> + */
> +extern struct extcon_dev *extcon_dev_allocate(const char **cables);
> +extern void extcon_dev_free(struct extcon_dev *edev);
> +
> +/*
>   * Following API get the extcon device from devicetree.
>   * This function use phandle of devicetree to get extcon device directly.
>   */
> @@ -353,5 +361,12 @@ static inline struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev,
>  {
>  	return ERR_PTR(-ENODEV);
>  }
> +
> +static inline struct extcon_dev *extcon_dev_allocate(const char **cables)
> +{
> +	return ERR_PTR(-ENOMEM);
> +}
> +
> +static inline void extcon_dev_free(struct extcon_dev *edev) { }
>  #endif /* CONFIG_EXTCON */
>  #endif /* __LINUX_EXTCON_H__ */
> 
> 
> here's full bisection log:
> 
> git bisect start
> # good: [a798c10faf62a505d24e5f6213fbaf904a39623f] Linux 3.15-rc2
> git bisect good a798c10faf62a505d24e5f6213fbaf904a39623f
> # bad: [3019b77470c1f10b23438917f73cad386e4f7f02] Merge branch 'extcon-next' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into merge
> git bisect bad 3019b77470c1f10b23438917f73cad386e4f7f02
> # bad: [f68f3aeb530b1efe3d6bf583db7a6255d15544eb] extcon: max14577: Use devm_extcon_dev_allocate for extcon_dev
> git bisect bad f68f3aeb530b1efe3d6bf583db7a6255d15544eb
> # good: [489096faca790b75653478d2f9d4774dd4f07b93] extcon: gpio: Use devm_extcon_dev_register()
> git bisect good 489096faca790b75653478d2f9d4774dd4f07b93
> # good: [5a451cded8793798e0d409e6ed6f8c53785ae929] extcon: arizona: Use devm_extcon_dev_register()
> git bisect good 5a451cded8793798e0d409e6ed6f8c53785ae929
> # bad: [cbe68e2d93df61fe40ddfea4d75f169fabadc155] extcon: Add devm_extcon_dev_allocate/free to manage the resource of extcon device
> git bisect bad cbe68e2d93df61fe40ddfea4d75f169fabadc155
> # bad: [854b85057cc6b90a326b731174b6c6dbbf34222a] extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
> git bisect bad 854b85057cc6b90a326b731174b6c6dbbf34222a
> # first bad commit: [854b85057cc6b90a326b731174b6c6dbbf34222a] extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
> 
> And the bug is very simple and affects *all* users of extcon class,
> which tells me that this big series switching over to devm_* resources
> wasn't tested at all. Originally extcon_dev_register() was calling
> device_register(&edev->dev) which will call device_initialize(dev)
> followed by device_add(dev).

This patchset add 'extcon_dev_allocate()' to allocate the memory of
extcon device. So, extcon_dev_allocate() calls 'device_initialize("
before calling extcon_dev_register() and then extcon_dev_register()
calls device_add() function as following.

edev = extcon_dev_allocate()
	{
		...
		device_initialize(&edev->dev) (line.683)
	}

ret = extcon_dev_register(edev)
	{
		...
		device_add(&edev->dev);
		...
	}

> 
> After this commit, extcon_dev_register() now calls
> device_add(&edev->dev) directly but never calls device_initialize()
> anywhere. Was this *ever* tested anywhere ????? I suppose not!

First of all,
I tested this patchset both normal case and error case.
- test environment : 3.15-rc2 with merging extcon-next branch

But,
As you comment, after merged this patch, extcon provider drvier
have to use both extcon_dev_allocate() and extcon_dev_register().
If only using extcon_dev_register(), will happen error as you comment.

Thanks,
Chanwoo Choi

