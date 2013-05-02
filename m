Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3EBHoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:44:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45692 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab3EBHoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:44:01 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Huang Shijie <b32955@freescale.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: RE: [PATCH V4 4/9] mtd: get the ECC info from the Extended
 Parameter Page
Thread-Topic: [PATCH V4 4/9] mtd: get the ECC info from the Extended
 Parameter Page
Thread-Index: AQHOQmAueOZgbGm9jUmSiG/Xic24jZjxizSA
Date: Thu, 2 May 2013 07:43:29 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9C0A90@DBDE04.ent.ti.com>
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>
 <1366967337-5534-5-git-send-email-b32955@freescale.com>
In-Reply-To: <1366967337-5534-5-git-send-email-b32955@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since the ONFI 2.1, the onfi spec adds the Extended Parameter Page
> to store the ECC info.
> 
> The onfi spec tells us that if the nand chip's recommended ECC codeword
> size is not 512 bytes, then the @ecc_bits is 0xff. The host _SHOULD_
> then
> read the Extended ECC information that is part of the extended
> parameter
> page to retrieve the ECC requirements for this device.
> 
> This patch implement the reading of the Extended Parameter Page, and
> parses
> the sections for ECC type, and get the ECC info from the ECC section.
> 
> Tested this patch with Micron MT29F64G08CBABAWP.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>

Acked-by: Pekon Gupta <pekon@ti.com>

Thanks..
with regards, pekon
