Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3EVBv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 21:51:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51386 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3EVBv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 21:51:56 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-1d-519c24ba4f4c
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] leds: leds-gpio: reserve gpio before using it.
Date: Wed, 22 May 2013 10:51:53 +0900
Message-id: <007201ce568e$ef3ead10$cdbc0730$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAGQ/qBA=
Content-language: ko
x-cr-hashedpuzzle: FN4t KLtE Q5S1 Snib UIMq Wg3h XqCe ZiqA btfX dL2a euQT iiSG
 kAgJ kj/f q2KX
 sYPT;5;YwBvAG8AbABvAG4AZQB5AEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBqAGgAYgBpAHIAZAAuAGMAaABvAGkAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBwAHUAcgBkAGkAZQBAAHIAcABzAHkAcwAuAG4AZQB0ADsAcwB0AGEAYgBsAGUAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{69A53402-1AF4-47E8-B586-4A12E582C874};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Wed,
 22 May 2013 01:51:44
 GMT;WwBQAEEAVABDAEgAIAAzAC4AOQAtAHMAdABhAGIAbABlAF0AIABsAGUAZABzADoAIABsAGUAZABzAC0AZwBwAGkAbwA6ACAAcgBlAHMAZQByAHYAZQAgAGcAcABpAG8AIABiAGUAZgBvAHIAZQAgAHUAcwBpAG4AZwAgAGkAdAAuAA==
x-cr-puzzleid: {69A53402-1AF4-47E8-B586-4A12E582C874}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zfd1dKnMCDSZv5rY4unMik8WSZm6L
	y7vmsFns3vWU1WLBxkeMDqweO2fdZffYM/8Hq0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	LP75hLngskrFy7O/2BoYZ8p3MXJySAiYSPzZc5sFwhaTuHBvPVsXIxeHkMAyRolpk6aywBQt
	+PyQCSIxnVGic/lLZgjnL6PEnXvHGUGq2AR0JY6t38IKYosIeEucmvKLGcRmFkiWmLj/IlA3
	B1ADt8Tq5iCQMKcAj8S6P51gJcICXhLfp65iArFZBFQlGt7fBRvDK2AnMenNQShbUOLH5Hss
	ECO1JNbvPM4EYctLbF7zlhlkvISAusSjv7ogpohAhcTyo/EQFSIS+168YwS5WELgDqvEtB2P
	2SD+MpWYfmsKVOIju8Slf/cZIW4QkPg2+RALxExZiU0HmCHqJSUOrrjBMoFRahaSi2YhuWgW
	kotmIdm9gJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZINPfuYLx9wPoQYzLQ+onMUqLJ
	+cBkkFcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	RhXLbcrnbj1iit/KfenAjmn2F37e2F6c2+FTtPTn2Ue7twitjXxzl+XuL1vmR2eE3VOi2B8z
	3j714tcZ3X8tTxRFNJdEFmn6euzdrvF998mNHcwrIx7KBnpMbV92OuXx809/bd0OmXkx2R80
	tmv/MbeyZ460YsLH3LK4GPYzsZFFq094X2zZxqbEUpyRaKjFXFScCAB+tgWE/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jQd1dKnMCDY4fYbM4unMik8WSZm6L
	y7vmsFns3vWU1WLBxkeMDqweO2fdZffYM/8Hq0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZiz++YS54LJKxcuzv9gaGGfKdzFyckgImEgs+PyQCcIW
	k7hwbz1bFyMXh5DAdEaJzuUvmSGcv4wSd+4dZwSpYhPQlTi2fgsriC0i4C1xasovZhCbWSBZ
	YuL+i0CTOIAauCVWNweBhDkFeCTW/ekEKxEW8JL4PnUV2DIWAVWJhvd3wcbwCthJTHpzEMoW
	lPgx+R4LxEgtifU7jzNB2PISm9e8ZQYZLyGgLvHory6IKSJQIbH8aDxEhYjEvhfvGEEulhC4
	wyoxbcdjNoi/TCWm35rCOIFRZBaSDbOQbJiFZMMsJLMWMLKsYhRNLUguKE5KzzXUK07MLS7N
	S9dLzs/dxAhOFc+kdjCubLA4xCjAwajEw/ugdnagEGtiWXFl7iFGCQ5mJRFew2tAId6UxMqq
	1KL8+KLSnNTiQ4zJwACYyCwlmpwPTGN5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJ
	zU5NLUgtgtnCxMEp1cDo0fIhZj5b8oupQbf72s7tccuf06Ex/+rkvb/+98/7Jh/0daq+qMb0
	xMvsRz/cXKuzZHU+x7PWb7vcbrQFL36sN7F9w5Pal1YGW/fHXJvl6+W0dcHN2jtvzqdsjdJs
	2btj3RQuyeXmOZo7+Q5Ff5yopNDIbz+DfVfZFX6ZqR5aYQ9F1knly797qsRSnJFoqMVcVJwI
	AJ1QW2VZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Timo Teras <timo.teras@iki.fi>"

commit 803d19d57a042e86e9e9b685bbc3f4a0a751040f upstream

This reverts commit a99d76f (leds: leds-gpio: use gpio_request_one)
and commit 2d7c22f (leds: leds-gpio: set devm_gpio_request_one()
flags param correctly) which was a fix of the first one.

The conversion to devm_gpio_request in commit e3b1d44c (leds:
leds-gpio: use devm_gpio_request_one) is not reverted.

The problem is that gpio_cansleep() and gpio_get_value_cansleep()
calls can crash if the gpio is not first reserved. Incidentally this
same bug existed earlier and was fixed similarly in commit d95cbe61
(leds: Fix potential leds-gpio oops). But the OOPS is real. It happens
when GPIOs are provided by module which is not yet loaded.

So this fixes the following BUG during my ALIX boot (3.9.2-vanilla):

BUG: unable to handle kernel NULL pointer dereference at 0000004c
IP: [<c11287d6>] __gpio_cansleep+0xe/0x1a
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: leds_gpio(+) via_rhine mii cs5535_mfd mfd_core
geode_rng rng_core geode_aes isofs nls_utf8 nls_cp437 vfat fat
ata_generic pata_amd pata_cs5536 pata_acpi libata ehci_pci ehci_hcd
ohci_hcd usb_storage usbcore usb_common sd_mod scsi_mod squashfs loop
Pid: 881, comm: modprobe Not tainted 3.9.2 #1-Alpine
EIP: 0060:[<c11287d6>] EFLAGS: 00010282 CPU: 0
EIP is at __gpio_cansleep+0xe/0x1a
EAX: 00000000 EBX: cf364018 ECX: c132b8b9 EDX: 00000000
ESI: c13993a4 EDI: c1399370 EBP: cded9dbc ESP: cded9dbc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: 0000004c CR3: 0f0c4000 CR4: 00000090
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process modprobe (pid: 881, ti=cded8000 task=cf094aa0 task.ti=cded8000)
Stack:
 cded9de0 d09471cb 00000000 c1399260 cf364014 00000000 c1399260 c1399254
 d0949014 cded9df4 c118cd59 c1399260 d0949014 d0949014 cded9e08 c118ba47
 c1399260 d0949014 c1399294 cded9e1c c118bb75 cded9e24 d0949014 00000000
Call Trace:
 [<d09471cb>] gpio_led_probe+0xba/0x203 [leds_gpio]
 [<c118cd59>] platform_drv_probe+0x26/0x48
 [<c118ba47>] driver_probe_device+0x75/0x15c
 [<c118bb75>] __driver_attach+0x47/0x63
 [<c118a727>] bus_for_each_dev+0x3c/0x66
 [<c118b6f9>] driver_attach+0x14/0x16
 [<c118bb2e>] ? driver_probe_device+0x15c/0x15c
 [<c118b3d5>] bus_add_driver+0xbd/0x1bc
 [<d08b4000>] ? 0xd08b3fff
 [<d08b4000>] ? 0xd08b3fff
 [<c118bffc>] driver_register+0x74/0xec
 [<d08b4000>] ? 0xd08b3fff
 [<c118c8e8>] platform_driver_register+0x38/0x3a
 [<d08b400d>] gpio_led_driver_init+0xd/0x1000 [leds_gpio]
 [<c100116c>] do_one_initcall+0x6b/0x10f
 [<d08b4000>] ? 0xd08b3fff
 [<c105e918>] load_module+0x1631/0x1907
 [<c10975d6>] ? insert_vmalloc_vmlist+0x14/0x43
 [<c1098d5b>] ? __vmalloc_node_range+0x13e/0x15f
 [<c105ec50>] sys_init_module+0x62/0x77
 [<c1257888>] syscall_call+0x7/0xb
EIP: [<c11287d6>] __gpio_cansleep+0xe/0x1a SS:ESP 0068:cded9dbc
CR2: 000000000000004c
 ---[ end trace 5308fb20d2514822 ]---

Signed-off-by: Timo Teras <timo.teras@iki.fi>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Raphael Assenat <raph@8d.com>
Cc: Trent Piepho <tpiepho@freescale.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/leds/leds-gpio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index a0d931b..b02b679 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -107,6 +107,10 @@ static int create_gpio_led(const struct gpio_led
*template,
 		return 0;
 	}
 
+	ret = devm_gpio_request(parent, template->gpio, template->name);
+	if (ret < 0)
+		return ret;
+
 	led_dat->cdev.name = template->name;
 	led_dat->cdev.default_trigger = template->default_trigger;
 	led_dat->gpio = template->gpio;
@@ -126,10 +130,7 @@ static int create_gpio_led(const struct gpio_led
*template,
 	if (!template->retain_state_suspended)
 		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
-	ret = devm_gpio_request_one(parent, template->gpio,
-				    (led_dat->active_low ^ state) ?
-				    GPIOF_OUT_INIT_HIGH :
GPIOF_OUT_INIT_LOW,
-				    template->name);
+	ret = gpio_direction_output(led_dat->gpio, led_dat->active_low ^
state);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.9.5

