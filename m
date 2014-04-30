Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110AbaD3JTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:19:43 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37908 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbaD3JTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:19:41 -0400
Date: Wed, 30 Apr 2014 10:19:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>,
        "Ezequiel Garcia (ezequiel.garcia@free-electrons.com)" 
	<ezequiel.garcia@free-electrons.com>
Subject: Re: [RFC 43/47] mtd: nand: stm_nand_bch: read and write functions
 (BCH)
Message-ID: <20140430091935.GI29462@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-44-git-send-email-lee.jones@linaro.org>
 <20980858CB6D3A4BAE95CA194937D5E73EAB5CC7@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAB5CC7@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From: Lee Jones [mailto:lee.jones@linaro.org]
> >
> >Helper function for bch_mtd_read() and bch_mtd_write() to handle
> >multi-page or non-aligned reads and writes respectively.
> >
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >---
> 
> I think below code is duplicate of nand_do_read_ops() and nand_do_write_ops()
> in nand_base.c. If you could just populate chip->ecc.read_page and
> chip->ecc.write_page much of this could be avoided.

chip->ecc.read_page and chip->ecc.write_page now populated.

> Also, you need to break your bch_read_page() into given generic NAND
> driver interfaces chip->ecc.calculate(), chip->ecc.correct() ...

Our h/w calculates and corrects automatically.  No need for
intervention.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
