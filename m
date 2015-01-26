Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbbAZLLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:11:19 -0500
Received: from mail.linn.co.uk ([195.59.102.251]:61840 "EHLO mail.linn.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbbAZLLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:11:17 -0500
Message-ID: <54C620CB.3010500@linn.co.uk>
Date: Mon, 26 Jan 2015 11:11:07 +0000
From: Stathis Voukelatos <stathis.voukelatos@linn.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <abrestic@chromium.org>
Subject: Re: [PATCH] net: Linn Ethernet Packet Sniffer driver
References: <1422007621-13567-1-git-send-email-stathis.voukelatos@linn.co.uk> <1422135432.18650.2.camel@perches.com>
In-Reply-To: <1422135432.18650.2.camel@perches.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.2.10.219]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24/01/15 21:37, Joe Perches wrote:
> On Fri, 2015-01-23 at 10:07 +0000, Stathis Voukelatos wrote:
>> This patch adds support the Ethernet Packet Sniffer H/W module
>> developed by Linn Products Ltd and found in the IMG Pistachio SoC.
>> The module allows Ethernet packets to be parsed, matched against
>> a user-defined pattern and timestamped. It sits between a 100M
>> Ethernet MAC and PHY and is completely passive with respect to
>> Ethernet frames.
> []
>>   include/linux/pkt_sniffer.h                        |  89 +++++
> Why should this file be here?
> Why not in the drivers/net/pkt-sniffer directory?
>
Hi Joe,
Thank you for the feedback.
This header file is the public API for the driver.
Should it not live under the 'include' directory?
Several other drivers seem to follow that convention.

I will include your other suggestions in the next version
of the patch set.
Thank you,
Stathis
