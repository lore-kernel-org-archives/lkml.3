Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaL2RxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:53:02 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:61950 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaL2Rw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:52:59 -0500
MIME-Version: 1.0
In-Reply-To: <1419597294-21487-3-git-send-email-sre@kernel.org>
References: <20141226102933.GA28778@amd>
	<1419597294-21487-1-git-send-email-sre@kernel.org>
	<1419597294-21487-3-git-send-email-sre@kernel.org>
Date: Mon, 29 Dec 2014 19:52:57 +0200
Message-ID: <CANOLnON6rAQ2+jJEFDKseH2Htu6bqRkURDioGt7zp1Ze73f8Pw@mail.gmail.com>
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
From: Grazvydas Ignotas <notasas@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Tony Lindgren <tony@atomide.com>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Menon, Nishanth" <nm@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 2:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> which can be used to determine the SoCs temperature. This patch provides
> a DT based driver for the temperature sensor based on an older driver
> written by Peter De Schrijver for the Nokia N900 and N9.

The sensor looks like an earlier iteration of sensors used in newer
OMAPs, which are already supported by maybe
drivers/thermal/ti-soc-thermal/ , maybe it would make sense to update
that driver instead?

--
Grazvydas
