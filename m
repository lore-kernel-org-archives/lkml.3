Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaDGMRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:17:36 -0400
Received: from smtp103.mer-nm.internl.net ([217.149.192.139]:56824 "EHLO
	smtp103.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbaDGMRa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:17:30 -0400
X-Spam-scanned: scanned by InterNLnet Mail Scan System
X-Spam-Flag: NO
X-Spam-Score: -2.9
X-Spam-Languages: en
Message-ID: <53429754.8080105@topic.nl>
Date: Mon, 7 Apr 2014 14:17:24 +0200
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <monstr@monstr.eu>, Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 2/5] ARM: zynq: dt: Convert to preprocessor includes
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com> <1396653256-28397-3-git-send-email-soren.brinkmann@xilinx.com> <53423E75.3020008@monstr.eu>
In-Reply-To: <53423E75.3020008@monstr.eu>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 04/07/2014 07:58 AM, Michal Simek wrote:
> Hi Soren,
>
> On 04/05/2014 01:14 AM, Soren Brinkmann wrote:
>> Convert all Zynq DT files to the dtc preprocessor include syntax.
>> This allows to include header files in the devicetrees like other
>> SoC-types already do.
>>
>> Inspired-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
>> (http://www.spinics.net/lists/arm-kernel/msg319832.html)
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>
> These 4 patches needs more wider discussion if this is helpful or
> not. Currently I can't see any value in it because everything
> is just generated and fixed. I think I had the same discussion
> with Laurent some weeks ago regarding this.

I would be kinda neutral here. I'd consider it helpful, it improves 
readability (regardless of whether they are generated or hand crafted). That's 
convenient for things like interrupt sensitivity, I can't remember whether 4 
is level or edge type. On the other hand, the clock indices are just as much 
magic numbers as the memory addresses. If I suspect an error in that area, I'd 
start by lokking in /sys/kernel/debug/clk but wouldn't start in the DT.

> IRC the origin idea to use this was especially for people who
> writing these DTS by hand which is not our case - at least
> for majority of our customers.

I write them by hand. Is there any other way?

Mike.


Met vriendelijke groet / kind regards,

Mike Looijmans

TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Visit us at the Hannover Messe 7 - 11 April 2014 - Hall 002/D10 (Dutch Pavillion)
http://www.hannovermesse.de/exhibitor/topic-embedded-products/V229623

