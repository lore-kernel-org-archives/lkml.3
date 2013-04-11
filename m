Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3DKTw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:52:59 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:36908 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3DKTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:52:58 -0400
Message-ID: <51671494.6000803@gmail.com>
Date: Thu, 11 Apr 2013 21:52:52 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Florian Fainelli <florian@openwrt.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Dale Farnsworth <dale@farnsworth.org>,
        Ben Hutchings <bhutchings@solarflare.com>, Soeren Moch <smoch@web.de>,
        Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mv643xx_eth: remove deprecated inet_lro support
References: <1365707488-28819-1-git-send-email-sebastian.hesselbarth@gmail.com> <1365709617.3887.185.camel@edumazet-glaptop>
In-Reply-To: <1365709617.3887.185.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 09:46 PM, Eric Dumazet wrote:
> On Thu, 2013-04-11 at 21:11 +0200, Sebastian Hesselbarth wrote:
>> With recent support for GRO, there is no need to keep both LRO and
>> GRO. This patch therefore removes the deprecated inet_lro support
>> from mv643xx_eth. This is work is based on an experimental patch
>> provided by Eric Dumazet and Willy Tarreau.
>>
>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>> Based-on-patch-by: Eric Dumazet<eric.dumazet@gmail.com>
>> Based-on-patch-by: Willy Tarreau<w@1wt.eu>
>> ---
>> Note: This patch is based upon recent cleanup patches and GRO support
>> patch for mv643xx_eth.
>>
>> Cc: "David S. Miller"<davem@davemloft.net>
>> Cc: Lennert Buytenhek<buytenh@wantstofly.org>
>> Cc: Andrew Lunn<andrew@lunn.ch>
>> Cc: Jason Cooper<jason@lakedaemon.net>
>> Cc: Florian Fainelli<florian@openwrt.org>
>> Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>> Cc: Paul Mackerras<paulus@samba.org>
>> Cc: Dale Farnsworth<dale@farnsworth.org>
>> Cc: Ben Hutchings<bhutchings@solarflare.com>
>> Cc: Soeren Moch<smoch@web.de>
>> Cc: Eric Dumazet<eric.dumazet@gmail.com>
>> Cc: Willy Tarreau<w@1wt.eu>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linuxppc-dev@lists.ozlabs.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   drivers/net/ethernet/marvell/mv643xx_eth.c |   97 +---------------------------
>>   1 file changed, 3 insertions(+), 94 deletions(-)
>
> Seems fine to me, but you also could remove "select INET_LRO"
> from drivers/net/ethernet/marvell/Kconfig

Ok, I will wait for tomorrow to see if there are more objections and
respin a v2.

Sebastian
