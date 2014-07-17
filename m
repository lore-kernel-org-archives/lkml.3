Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaGQR2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:28:15 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33518 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaGQR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:28:14 -0400
MIME-Version: 1.0
Reply-To: markus@gutschke.com
In-Reply-To: <1405587482.28592.64.camel@rzhang1-toshiba>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
 <CALGCz1oYYkKp1frPF4vExiwqW=euYY8An+Yum4U-qsBc5NyjFg@mail.gmail.com> <1405587482.28592.64.camel@rzhang1-toshiba>
From: Markus Gutschke <markus@gutschke.com>
Date: Thu, 17 Jul 2014 10:27:51 -0700
X-Google-Sender-Auth: P5fz00-hYiwpATLoSvXulTitr64
Message-ID: <CALGCz1qzmK_0Mq8JNFYUnGtDGWSqYoHfqv0MKbqG1RySQ4bt6g@mail.gmail.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please note the crash in "dmesg" right after booting. This looks relevant:

https://medusa.gutschke.com/markus/acpi/after-dmesg.txt
https://medusa.gutschke.com/markus/acpi/acpidump.txt
https://medusa.gutschke.com/markus/acpi/before-platform-devices-firmware-node.txt
https://medusa.gutschke.com/markus/acpi/before-platform-devices.txt
https://medusa.gutschke.com/markus/acpi/before-pnp-devices-firmware-node.txt
https://medusa.gutschke.com/markus/acpi/before-pnp-devices.txt
https://medusa.gutschke.com/markus/acpi/after-platform-devices-firmware-node.txt
https://medusa.gutschke.com/markus/acpi/after-platform-devices.txt
https://medusa.gutschke.com/markus/acpi/after-pnp-devices-firmware-node.txt
https://medusa.gutschke.com/markus/acpi/after-pnp-devices.txt


Markus
