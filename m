Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3EBHnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:43:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40567 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3EBHn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:43:28 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Huang Shijie <b32955@freescale.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: RE: [PATCH V4 2/9] mtd: add data structures for Extended Parameter
 Page
Thread-Topic: [PATCH V4 2/9] mtd: add data structures for Extended Parameter
 Page
Thread-Index: AQHOQl+MThU+Crcj4Umg/meHa5ZGQpjxjAnw
Date: Thu, 2 May 2013 07:42:58 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9C0A84@DBDE04.ent.ti.com>
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>
 <1366967337-5534-3-git-send-email-b32955@freescale.com>
In-Reply-To: <1366967337-5534-3-git-send-email-b32955@freescale.com>
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
> This patch adds
>     [1] the neccessary fields for nand_onfi_params{},
>     [2] and adds the onfi_ext_ecc_info{} for Extended ECC information,
>     [3] adds onfi_ext_section{} for extended sections,
>     [4] and adds onfi_ext_param_page{} for the Extended Parameter
> Page.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>

Acked-by: Pekon Gupta <pekon@ti.com>

Thanks..
with regards, pekon
