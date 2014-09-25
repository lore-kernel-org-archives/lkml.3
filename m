Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaIYRHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:07:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48016 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbaIYRHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:07:00 -0400
Message-ID: <54244B92.4020004@ti.com>
Date: Thu, 25 Sep 2014 13:06:26 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Nair, Sandeep" <sandeep_n@ti.com>
Subject: Re: [PATCH v4 2/3] net: Add Keystone NetCP ethernet driver
References: <1411653805-29257-1-git-send-email-santosh.shilimkar@ti.com>	 <1411653805-29257-3-git-send-email-santosh.shilimkar@ti.com> <1411655363.4026.13.camel@joe-AO725>
In-Reply-To: <1411655363.4026.13.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014 10:29 AM, Joe Perches wrote:
> On Thu, 2014-09-25 at 10:03 -0400, Santosh Shilimkar wrote:
>> From: Sandeep Nair <sandeep_n@ti.com>
>>
>> The network coprocessor (NetCP) is a hardware accelerator that processes
>> Ethernet packets. NetCP has a gigabit Ethernet (GbE) subsystem with a ethernet
>> switch sub-module to send and receive packets. NetCP also includes a packet
>> accelerator (PA) module to perform packet classification operations such as
>> header matching, and packet modification operations such as checksum
>> generation. NetCP can also optionally include a Security Accelerator(SA)
>> capable of performing IPSec operations on ingress/egress packets.
> 
> Some checkpatch trivia you might consider:
Sure. I fold that in. Thanks !!

regards,
Santosh

