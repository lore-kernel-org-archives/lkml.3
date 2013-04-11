Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161565Ab3DKSHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:07:23 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:55104 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3DKSHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:07:21 -0400
Message-ID: <5166FBD4.5020508@gmail.com>
Date: Thu, 11 Apr 2013 20:07:16 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Soeren Moch <smoch@web.de>, "David S. Miller" <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Florian Fainelli <florian@openwrt.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Dale Farnsworth <dale@farnsworth.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mv643xx_eth: Add GRO support
References: <1365684023-9967-1-git-send-email-sebastian.hesselbarth@gmail.com> <1365702955.7355.5.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1365702955.7355.5.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 07:55 PM, Ben Hutchings wrote:
> On Thu, 2013-04-11 at 14:40 +0200, Sebastian Hesselbarth wrote:
>> This patch adds GRO support to mv643xx_eth by making it invoke
>> napi_gro_receive instead of netif_receive_skb.
>
> The inet_lro support should be removed at the same time; inet_lro is now
> deprecated and there should be no need to keep both of them.

Ben,

I agree on removing it asap, but I also like to see GRO support
in. Maybe, we postpone lro removal just a little bit. I have just
started to look at mv643xx_eth and remember Marvell Orion SoCs are
not the only platform using it. I haven't heard a single word from
ppc guys, yet.

Willy just posted an experimental patch to remove lro. I'll have
a look at it and test it out on Dove.

Sebastian
