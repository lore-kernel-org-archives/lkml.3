Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaJ0XE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:04:28 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46022 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJ0XE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:04:27 -0400
Message-ID: <544ECF84.80208@gmail.com>
Date: Tue, 28 Oct 2014 00:04:36 +0100
From: Roberto Medina <robertoxmed@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: realtek: atp: checkpatch errors and warnings
 corrected
References: <1414084200-5377-1-git-send-email-robertoxmed@gmail.com>	<20141027.185211.1433818002293610983.davem@davemloft.net> <20141027.185355.1412632964802440855.davem@davemloft.net>
In-Reply-To: <20141027.185355.1412632964802440855.davem@davemloft.net>
Content-Type: text/plain; charset=iso-8859-7; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 11:53 PM, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 27 Oct 2014 18:52:11 -0400 (EDT)
>
>> From: Roberto Medina <robertoxmed@gmail.com>
>> Date: Thu, 23 Oct 2014 19:10:00 +0200
>>
>>> From: Roberto Medina <robertoxmed@gmail.com>
>>>
>>> Several warnings and errors of coding style errors corrected.
>>>
>>> Signed-off-by: Roberto Medina <robertoxmed@gmail.com>
>>
>> Applied, thanks.
>
> Wait, are you serious, you didn't even compile test this change?
>
> For real?
>
> In file included from drivers/net/ethernet/realtek/atp.c:146:0:
> drivers/net/ethernet/realtek/atp.h:79:15: error: expected ¡;¢, identifier or ¡(¢ before ¡unsigned¢
>   static inline unsigned char inbyte(unsigned short port)
>                 ^
> drivers/net/ethernet/realtek/atp.h:79:15: error: ¡inline¢ in empty declaration
>

Wow I'm really sorry for that, I did compile my changes, or at least 
that's what I thought when I compiled the directory.

Will submit another patch. Sorry for the inconvenience again.

> Don't even submit changes meant for inclusion if you're not even
> willing to build test them.
>
> And I'm very serious about this.
>

