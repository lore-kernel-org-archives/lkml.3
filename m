Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaEHOjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:39:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35728 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaEHOjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:39:00 -0400
Message-ID: <536B96E6.9090000@ti.com>
Date: Thu, 8 May 2014 20:08:30 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>, Tony Lindgren <tony@atomide.com>
CC: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: AM33XX: fix ethernet and mdio default state
References: <1399539456-555-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1399539456-555-1-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2014 02:27 PM, Johan Hovold wrote:
> Make sure ethernet and mdio nodes are disabled by default and enable
> them explicitly only on boards that actually use them.
>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
