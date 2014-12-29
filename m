Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaL2SBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 13:01:07 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:57981 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaL2SBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 13:01:04 -0500
MIME-Version: 1.0
In-Reply-To: <CANOLnON6rAQ2+jJEFDKseH2Htu6bqRkURDioGt7zp1Ze73f8Pw@mail.gmail.com>
References: <20141226102933.GA28778@amd>
	<1419597294-21487-1-git-send-email-sre@kernel.org>
	<1419597294-21487-3-git-send-email-sre@kernel.org>
	<CANOLnON6rAQ2+jJEFDKseH2Htu6bqRkURDioGt7zp1Ze73f8Pw@mail.gmail.com>
Date: Mon, 29 Dec 2014 12:01:03 -0600
X-Google-Sender-Auth: IBG5F5K6YWuzJWY9JbdfV6-JzsQ
Message-ID: <CAGo_u6qO0ok+GBnm7SQtw6dJuwGN2OuP7CpKDEWawS3V2go4KA@mail.gmail.com>
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
From: Nishanth Menon <nm@ti.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        dt list <devicetree@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Jean Delvare <jdelvare@suse.de>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 11:52 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> On Fri, Dec 26, 2014 at 2:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
>> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
>> which can be used to determine the SoCs temperature. This patch provides
>> a DT based driver for the temperature sensor based on an older driver
>> written by Peter De Schrijver for the Nokia N900 and N9.
>
> The sensor looks like an earlier iteration of sensors used in newer
> OMAPs, which are already supported by maybe
> drivers/thermal/ti-soc-thermal/ , maybe it would make sense to update
> that driver instead?

Just to be clear - OMAP4 is the first time that the sensors were
reliable enough to be used.

---
Regards,
Nishanth Menon
