Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbbATPxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:53:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40465 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbbATPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:53:38 -0500
Message-ID: <54BE7A00.2020205@ti.com>
Date: Tue, 20 Jan 2015 10:53:36 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v8 0/4] net: Add Keystone NetCP ethernet driver
 support
References: <1421367007-19744-1-git-send-email-m-karicheri2@ti.com> <20150119.151106.822126941934010309.davem@davemloft.net>
In-Reply-To: <20150119.151106.822126941934010309.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 03:11 PM, David Miller wrote:
> From: Murali Karicheri<m-karicheri2@ti.com>
> Date: Thu, 15 Jan 2015 19:10:03 -0500
>
>> The Network Coprocessor (NetCP) is a hardware accelerator that processes
>> Ethernet packets. NetCP has a gigabit Ethernet (GbE) subsystem with a ethernet
>> switch sub-module to send and receive packets. NetCP also includes a packet
>> accelerator (PA) module to perform packet classification operations such as
>> header matching, and packet modification operations such as checksum
>> generation. NetCP can also optionally include a Security Accelerator(SA)
>> capable of performing IPSec operations on ingress/egress packets.
>>
>> Keystone SoC's also have a 10 Gigabit Ethernet Subsystem (XGbE) which
>> includes a 3-port Ethernet switch sub-module capable of 10Gb/s and
>> 1Gb/s rates per Ethernet port.
>>
>> Both GBE and XGBE network processors supported using common driver. It
>> is also designed to handle future variants of NetCP.
>
> Series applied to net-next, thanks.
David,

Thanks a lot for applying this series. This helps us move forward to 
work on the next set of patches.

Thanks
-- 
Murali Karicheri
Linux Kernel, Texas Instruments
