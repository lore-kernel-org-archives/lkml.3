Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaDQUyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:54:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44347 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbaDQUww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:52:52 -0400
Message-ID: <53503F06.3050707@ti.com>
Date: Thu, 17 Apr 2014 16:52:22 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 02/19] bus: omap_l3_noc: rename functions and data
 to omap_l3
References: <1397492726-17203-1-git-send-email-nm@ti.com> <1397767775-10965-1-git-send-email-nm@ti.com> <1397767775-10965-3-git-send-email-nm@ti.com>
In-Reply-To: <1397767775-10965-3-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2014 04:49 PM, Nishanth Menon wrote:
> From: Sricharan R <r.sricharan@ti.com>
> 
> Since omap_l3_noc driver is now being used for OMAP5 and reusable with
> DRA7 and AM437x, using omap4 specific naming is misleading.
> 
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> 
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

