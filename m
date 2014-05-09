Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaEIKiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:38:55 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37226 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEIKiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:38:52 -0400
Date: Fri, 9 May 2014 11:38:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>
Subject: Re: [RFC 13/47] mtd: nand: stm_nand_bch: provide Device Tree support
Message-ID: <20140509103846.GS5767@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-14-git-send-email-lee.jones@linaro.org>
 <20980858CB6D3A4BAE95CA194937D5E73EAB5C83@DBDE04.ent.ti.com>
 <20140430125406.GN29462@lee--X1>
 <20980858CB6D3A4BAE95CA194937D5E73EACA3F0@DBDE04.ent.ti.com>
 <20140509100304.GR5767@lee--X1>
 <20980858CB6D3A4BAE95CA194937D5E73EACBC8F@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EACBC8F@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Ah, I see.  I will fixup, thanks for the explanation.
> >
> 
> Please wait, I'll review your [v2] series also, then you can further
> send all fixes together. I'm bit caught in other commitments for 3.16,
> so hopefully I'll be able to review your patches by next week.

I have already fixed up, but I won't resubmit until you have
reviewed.

FYI: I have made some changes since v2 including moving over to the
recently submitted core timing structure submitted by Boris Brezillon
and removal bitflip_threshold as an internal variable.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
