Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaI2VsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:48:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49156 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbaI2VsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:48:17 -0400
Message-ID: <5429D384.1040909@ti.com>
Date: Mon, 29 Sep 2014 17:47:48 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <sandeep_n@ti.com>, <joe@perches.com>
Subject: Re: [PATCH v5 2/3] net: Add Keystone NetCP ethernet driver
References: <1411667317-1163-3-git-send-email-santosh.shilimkar@ti.com>	<20140929.155200.2231132602322345812.davem@davemloft.net>	<5429BAD0.1050101@ti.com> <20140929.161253.1302757975839499212.davem@davemloft.net>
In-Reply-To: <20140929.161253.1302757975839499212.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 04:12 PM, David Miller wrote:
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Mon, 29 Sep 2014 16:02:24 -0400
> 
>> We are badly missing mainline network driver support for the Keystone
>> and hence I request you to help here.
> 
> It is absolutely not reasonable for you depend specifically upon me
> for top-level review of a given change, sorry.
> 
Sorry I didn't mean you specifically to review everything. But a guidance
on how we can move forward. If you can suggest someone, we can try to
request them to have a look. The design of driver is just now standard
NIC card. We removed the controversial plug in framework after your
and Jamal's suggestion. Jamal already commented on the offload design of
the driver and we addressed them in the last version.

We can follow it up on any comments, suggestions quickly so do let us
know.

Regards,
Santosh







