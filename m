Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaGDJuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:50:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54375 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaGDJuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:50:00 -0400
Message-ID: <53B678C1.4000807@ti.com>
Date: Fri, 4 Jul 2014 12:49:53 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>, <tony@atomide.com>
CC: <rnayak@ti.com>, <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ARM: DRA7: hwmod: Add OCP2SCP3 module
References: <1404385274-5093-1-git-send-email-rogerq@ti.com> <1404385274-5093-2-git-send-email-rogerq@ti.com> <alpine.DEB.2.02.1407031948110.1515@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1407031948110.1515@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul & Tony,

On 07/03/2014 10:48 PM, Paul Walmsley wrote:
> On Thu, 3 Jul 2014, Roger Quadros wrote:
> 
>> This module is needed for the SATA and PCIe PHYs.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Reviewed-by: Rajendra Nayak <rnayak@ti.com>
>> Tested-by: Sekhar Nori <nsekhar@ti.com>>
> 
> This looks like adding support for a new device, so, after 
> discussing with Tony, queuing for v3.17.

We should treat it as missing device (bug) rather than new device (feature) as the corresponding device tree node is already present.
Without this patch we get the following message in kernel boot log

[    0.261680] platform 4a090000.ocp2scp: Cannot lookup hwmod 'ocp2scp3'

I would consider this patch as a fix rather than a new feature.

cheers,
-roger
