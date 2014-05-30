Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbaE3Lfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:35:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56538 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbaE3Lfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:35:50 -0400
Message-ID: <53886CB7.4070104@ti.com>
Date: Fri, 30 May 2014 17:04:15 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Sourav Poddar <sourav.poddar@ti.com>, <bcousson@baylibre.com>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Menon, Nishanth" <nm@ti.com>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [Resend/PATCH] arm: dts: dra7: Add qspi device.
References: <1399374445-16456-1-git-send-email-sourav.poddar@ti.com> <20140506165254.GN18474@atomide.com>
In-Reply-To: <20140506165254.GN18474@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 06 May 2014 10:22 PM, Tony Lindgren wrote:
> * Sourav Poddar <sourav.poddar@ti.com> [140506 04:08]:
>> These add device tree entry for qspi controller driver on dra7-evm.
> Thanks applying into omap-for-v3.16/dt.
There is a problem with this. The qspi node defines crossbar number
 as its interrupt number. Since the crossbar dts patches are not yet
 there, this causes a warning during boot.  So interrupts = < >
 property should be removed from DT and added later by crossbar series.

Regards,
Sricharan

