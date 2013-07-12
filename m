Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab3GLGvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 02:51:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41952 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab3GLGvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 02:51:54 -0400
Message-ID: <51DFA768.9090703@ti.com>
Date: Fri, 12 Jul 2013 12:21:20 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] ARM: davinci: da850: add ethernet driver DT support
References: <1371999607-6483-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8t-sTPAK+D5869X0_ZCdrmK0B+eRaowk9hMYwXMw09NqA@mail.gmail.com>
In-Reply-To: <CA+V-a8t-sTPAK+D5869X0_ZCdrmK0B+eRaowk9hMYwXMw09NqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/2013 10:42 PM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> On Sun, Jun 23, 2013 at 8:30 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch set enables Ethernet support through device tree model.
>> This patch set enables mii interface only and is being tested to boot via
>> rootfs. The rmii phy is present on the i2c gpio expander chip (UI board)
>> for which yet support needs to be added, once the DT support for the chip
>> is enabled, enabling rmii will be subsequnet patch.
>>
>> Changes for v2:
>> 1: Enabled mdio device.
>> 2: Fixed clock lookup.
>>
>> Changes for v3:
>> 1: Fixed review comments pointed out by Sekhar.
>>
>> Lad, Prabhakar (6):
>>   ARM: davinci: da8xx: fix clock lookup for mdio device
>>   ARM: davinci: da850: add DT node for mdio device
>>   ARM: davinci: da850: add OF_DEV_AUXDATA entry for mdio.
>>   ARM: davinci: da850: add DT node for eth0.
>>   ARM: davinci: da850: add OF_DEV_AUXDATA entry for eth0.
>>   ARM: davinci: da850: configure system configuration chip(CFGCHIP3)
>>     for emac
>>
> gentle ping..

I haven't been able to get to reviewing patches meant for v3.12 yet.
Most probably will happen next week.

Thanks,
Sekhar
