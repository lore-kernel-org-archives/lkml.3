Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298Ab3DHJcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:32:32 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:60009 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934732Ab3DHJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:32:30 -0400
Message-ID: <51628E98.2070709@openwrt.org>
Date: Mon, 08 Apr 2013 11:32:08 +0200
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mvmdio: get and enable optional clock
References: <1365332988-9053-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1365332988-9053-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/07/13 13:09, Sebastian Hesselbarth a écrit :
> Marvell mdio driver uses internal registers that can be clock gated on
> some SoCs. This patch just adds optional clock handling, to allow to pass
> and enable the corresponding clock.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Looks good to me:

Acked-by: Florian Fainelli <florian@openwrt.org>
--
Florian
