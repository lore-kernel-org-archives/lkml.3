Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966167Ab3E2TGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:06:03 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43437 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966039Ab3E2TFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:05:47 -0400
Message-ID: <51A65185.1020307@gmail.com>
Date: Wed, 29 May 2013 21:05:41 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130529190204.6058.85682@quantum>
In-Reply-To: <20130529190204.6058.85682@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 09:02 PM, Mike Turquette wrote:
> Quoting Sebastian Hesselbarth (2013-05-10 18:08:00)
>> Marvell EBU SoCs share some common clock functions that register core
>> clocks or clock gates from SoC specific data. These clock drivers are
>> organized by function and over time the drivers filled up with #ifdefs
>> to separate different SoC specific code.
>>
...
>> @Mike: As this only touches MVEBU related code, I suggest to take it
>> all through the corresponding ARM branch.
>>
> Sorry for the tardy response.  This cleanup looks really good.  If it's
> not too late:
>
> Acked-by: Mike Turquette<mturquette@linaro.org>
>
> If the branch is already pulled into arm-soc don't worry about the Ack.

Mike,

thanks for the Ack, the corresponding pull request has been sent some
hours ago by Jason Cooper. It has not been pulled into arm-soc, so it
is just in time ;)

Sebastian
