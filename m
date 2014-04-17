Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaDQUz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:55:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38307 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbaDQUxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:53:09 -0400
Message-ID: <53503F1C.9040309@ti.com>
Date: Thu, 17 Apr 2014 16:52:44 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 03/19] bus: omap_l3_noc: remove iclk from omap_l3 struct
References: <1397492726-17203-1-git-send-email-nm@ti.com> <1397767775-10965-1-git-send-email-nm@ti.com> <1397767775-10965-4-git-send-email-nm@ti.com>
In-Reply-To: <1397767775-10965-4-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2014 04:49 PM, Nishanth Menon wrote:
> we do not use iclk directly anymore. And, even if we had to, we
> should be using pm_runtime APIs to do the same to be completely SoC
> independent.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

