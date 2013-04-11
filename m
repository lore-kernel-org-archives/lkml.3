Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936012Ab3DKJcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:32:43 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:58449 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935661Ab3DKJcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:32:41 -0400
Message-ID: <5166831E.9090105@openwrt.org>
Date: Thu, 11 Apr 2013 11:32:14 +0200
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] net: mv643xx_eth: use managed clk and allocation
References: <1365672574-31123-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1365672574-31123-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/11/13 11:29, Sebastian Hesselbarth a écrit :
> With introduction of common clock framework and the ability to provide
> gated clocks, mv643xx_eth required calls to get and enable these clock
> gates on some platforms. Back then, common clock framework api wasn't
> safe for architectures without support for common clocks. This has
> changed now and there are also managed (devm_) counterparts for clock
> related functions.
>
> The second patch in this series, also converts kzalloc to devm_kzalloc
> where applicable.
>
> Both patches have been sent to the corresponding mailing lists as
> individual patches before. To get the order required to apply them right,
> this patch set combines both patches into one set.
>
> Sebastian Hesselbarth (2):
>    net: mv643xx_eth: add shared clk and cleanup existing clk handling
>    net: mv643xx_eth: use managed devm_kzalloc

Looks good, thanks Sebastian!

Acked-by: Florian Fainelli <florian@openwrt.org>
--
Florian
