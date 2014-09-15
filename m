Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaIOHwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:52:40 -0400
Received: from vif1-retry101.mer-nm.internl.net ([217.149.192.107]:42611 "EHLO
	retry101.mer-nm.internl.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752380AbaIOHwi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:52:38 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 03:52:37 EDT
X-Spam-Flag: NO
X-Spam-Score: -2.9
X-Spam-Languages: en
Message-ID: <541698F5.2010401@topic.nl>
Date: Mon, 15 Sep 2014 09:44:53 +0200
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/phy: micrel: Disable asymmetric pause for KSZ9031
References: <5411ECE9.8050600@gmail.com>	<1410525637-849-1-git-send-email-mike.looijmans@topic.nl> <20140912.181820.1440041146938289489.davem@davemloft.net>
In-Reply-To: <20140912.181820.1440041146938289489.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 09/13/2014 12:18 AM, David Miller wrote:
> From: Mike Looijmans <mike.looijmans@topic.nl>
> Date: Fri, 12 Sep 2014 14:40:37 +0200
>
>> The KSZ9031 appears to suffer from the same hardware bug as described
>> for the KSZ9021 in commit 32fcafbcd1c9f6c7013016a22a5369b4acb93577
>> ("net/phy: micrel: Disable asymmetric pause for KSZ9021")
>> you have to unplug the cable and plug it back to get it to work.
>>
>> Remove the SUPPORTED_Asym_Pause flag for the KSZ9031 to fix this.
>>
>> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
>
> This patch does not apply cleanly to the net tree, please respin.
>

Okay, just tell me where to find this branch?

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

Topic zoekt gedreven (embedded) software specialisten!
http://topic.nl/vacatures/topic-zoekt-software-engineers/

