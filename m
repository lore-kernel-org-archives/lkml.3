Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3CMKzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:55:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:25469 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab3CMKzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:55:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,834,1355126400"; 
   d="scan'208";a="301696597"
Message-ID: <1363172157.11441.12.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V4 2/3] mtd: add 4 Toshiba nand chips for the full-id
 case
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 12:55:57 +0200
In-Reply-To: <1362653364-29993-3-git-send-email-b32955@freescale.com>
References: <1362653364-29993-1-git-send-email-b32955@freescale.com>
	 <1362653364-29993-3-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 18:49 +0800, Huang Shijie wrote:
> +	/* TOSHIBA */
> +	{"TC58NVG2S0F 4G 3.3V 8-bit",
> +		{ .id = {0x98, 0xdc, 0x90, 0x26, 0x76, 0x15, 0x01, 0x08}},
> +			SZ_4K, SZ_512, SZ_256K, 0, 8, 224},
> +	{"TC58NVG3S0F 8G 3.3V 8-bit",
> +		{ .id = {0x98, 0xd3, 0x90, 0x26, 0x76, 0x15, 0x02, 0x08}},
> +			SZ_4K, SZ_1K, SZ_256K, 0, 8, 232},
> +	{"TC58NVG5D2 32G 3.3V 8-bit",
> +		{ .id = {0x98, 0xd7, 0x94, 0x32, 0x76, 0x56, 0x09, 0x00}},
> +			SZ_8K, SZ_4K, SZ_1M, 0, 8, 640},
> +	{"TC58NVG6D2 64G 3.3V 8-bit",
> +		{ .id = {0x98, 0xde, 0x94, 0x82, 0x76, 0x56, 0x04, 0x20}},
> +			SZ_8K, SZ_8K, SZ_2M, 0, 8, 640},

We need a useful comment above this block explaining that it is
important to have full ID records first.

-- 
Best Regards,
Artem Bityutskiy

