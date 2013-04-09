Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936903Ab3DIIje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:39:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46103 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935660Ab3DIIja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:39:30 -0400
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 0/6] mfd: omap-usb-host: Device tree support for 3.10
Date: Tue, 9 Apr 2013 11:39:16 +0300
Message-ID: <1365496758-16287-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20130409075457.GF24058@zurbaran>
References: <20130409075457.GF24058@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,

You had the conflicts because a patch [*] was introduced and is not
required since the reset logic is being removed from the driver.

Anyways, I've rebased the 2 patches on top of mfd-next, so now it
shouldn't matter.

cheers,
-roger

[*]
commit 71f4b9cdfccfb82cff702fe61f4ace97a1dfb0e0
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Wed Feb 20 18:29:30 2013 +0900

    mfd: omap-usb-host: Use devm_gpio_request_one()

