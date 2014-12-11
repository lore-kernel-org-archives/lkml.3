Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaLKMYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:24:06 -0500
Received: from mx0.aculab.com ([213.249.233.131]:46586 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751514AbaLKMYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:24:03 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>, "kishon@ti.com" <kishon@ti.com>,
        "k.debski@samsung.com" <k.debski@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>
Subject: RE: [PATCH 0/4] phy: samsung-usb2: Add support for Vbus regulator
Thread-Topic: [PATCH 0/4] phy: samsung-usb2: Add support for Vbus regulator
Thread-Index: AQHQFTtby0z0s1gFjkODdkIEdARUfJyKTsTg
Date: Thu, 11 Dec 2014 12:22:56 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CA0B0EB@AcuExch.aculab.com>
References: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Gautam
> This has been on my to-do list for sometime.
> Until now the host controller (specifically ehci-exynos) is responsible
> for enabling VBUS supply. This opens up one more issue which is, when
> only ohci-exynos is enabled and ehci-exynosis disabled then VBUS was
> never enabled (since ohci did not have the code to enabled the VBUS supply).
> 
> Rather it should be wise to move the VBUS related stuff to phy driver and
> let phy take care of enabling it.
> 
> This patch series adds that VBUS regulator to phy-samsung-usb2 driver,
> adds necessary binding information as well as vbus-supply properties
> to phy nodes on exynos5250 systems.
...

Does this go anyway to allowing devices to be powered from a micro-usb
connector while acting as a USB host (USB OTG).
ie when you want VBUS disabled even though it would normally
need to be enabled.

	David



