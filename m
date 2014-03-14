Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbaCNGnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:43:32 -0400
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:34421 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755256AbaCNGna convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:43:30 -0400
X-Spam-scanned: scanned by InterNLnet Mail Scan System
X-Spam-Flag: NO
X-Spam-Score: -4.4
X-Spam-Languages: en
Message-ID: <5322A50D.4040702@topic.nl>
Date: Fri, 14 Mar 2014 07:43:25 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <khilman@deeprootsystems.com>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl> <20140309202107.GA2835@katana> <531D92F7.7080509@topic.nl> <20140310105952.GA7227@katana> <20140310152406.GD11592@katana>
In-Reply-To: <20140310152406.GD11592@katana>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 03/10/2014 04:24 PM, Wolfram Sang wrote:
>
>>>> Even more, you should complete the whole transfer. There are devices
>>>> where things can really go wrong if you send a half-complete command and
>>>> then start with the next one. So, not checking signals at all is the way
>>>> to go for I2C drivers. There is some cruft left, so I am happy about
>>>> patches fixing that, with testing on real HW. Like yours here.
>>>
>>> I agree.
>>>
>>> I know the Zynq (using a cadence controller) also lets signals
>>> interrupt I2C transfers, so I'll propose a patch to Xilinx and CC to
>>> you and linux-i2c to completely remove signal handling from that
>>> driver as well.
>>
>> Cool, thanks!
>
> Are you going to update the davinci patch as well?

An amended patch is on its way now. I forgot to set the subject to "PATCHv2" 
though.

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

