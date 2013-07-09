Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3GIKdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:33:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41822 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3GIKc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:32:58 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Cherian, George" <george.cherian@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: [PATCH v2] arm: dts: AM43x: Add usb_otg_hs node
Thread-Topic: [PATCH v2] arm: dts: AM43x: Add usb_otg_hs node
Thread-Index: AQHOfIUxZ3JRNeejZEKGX4bz7p/ob5lcJJWQ
Date: Tue, 9 Jul 2013 10:32:19 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EB30355@DBDE04.ent.ti.com>
References: <1373361446-30050-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1373361446-30050-1-git-send-email-george.cherian@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On Tue, Jul 09, 2013 at 14:47:26, Cherian, George wrote:

> +		usb_otg_hs1: am4372_dwc3@48380000 {

Wouldn't "usb" a better node name ?

> +			compatible = "ti,am437x-dwc3";

Usage of wild card is discouraged per DT documentation.

Regards
Afzal

