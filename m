Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbaD2Nmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:42:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51830 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbaD2Nmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:42:42 -0400
Message-ID: <535FAC36.10408@ti.com>
Date: Tue, 29 Apr 2014 19:12:14 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 00/20] bus: omap_l3_noc: driver cleanups and support
 for DRA7/AM4372
References: <1397492726-17203-1-git-send-email-nm@ti.com> <1398698101-25513-1-git-send-email-nm@ti.com>
In-Reply-To: <1398698101-25513-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2014 08:44 PM, Nishanth Menon wrote:
> V3: has the following changes (w.r.t v2):
> 	- fixed relaxed commit message and usage.
> 	- AM437x internal documents showed that:
> 		- new master information updated into the data
> 		- masterid register definition is different from OMAP4-DRA7 - some
> 		  additional parsing is done in hardware to "avoid s/w parsing"
> 	- Additional testing information showed logic fail for masking "unclearable"
> 		new patch added to series - patch #15
> 	- Picked up previous acks and tested by - minor changes verified

Tested the series on AM437x ePOS EVM and works great.

Tested-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
