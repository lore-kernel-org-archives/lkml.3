Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaCJKVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:21:20 -0400
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:56191 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbaCJKVS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:21:18 -0400
X-Spam-scanned: scanned by InterNLnet Mail Scan System
X-Spam-Flag: NO
X-Spam-Score: -4.4
X-Spam-Languages: en
Message-ID: <531D921A.80404@topic.nl>
Date: Mon, 10 Mar 2014 11:21:14 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <nsekhar@ti.com>, <khilman@deeprootsystems.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mike Looijmans <milo-software@users.sourceforge.net>
Subject: Re: [PATCH] i2c-davinci: Implement a bus recovery that actually works
References: <1393583525-9555-1-git-send-email-mike.looijmans@topic.nl> <20140309202841.GB2835@katana> <531D619F.5000803@topic.nl> <20140310072631.GA2571@katana>
In-Reply-To: <20140310072631.GA2571@katana>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 03/10/2014 08:26 AM, Wolfram Sang wrote:
>
>> I won't be doing those changes though. My sponsor's budget is
>> limited, so I'm just having to do the minimum I can get away with.
>
> Pity. Are you available for testing in case someone comes up with a
> patch?
>

Not really, the customer is using a 2.6.37 kernel, and that's currently the 
only board we have with an OMAP-L1.

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

