Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbbA0Jwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:52:40 -0500
Received: from mail.linn.co.uk ([195.59.102.251]:65410 "EHLO mail.linn.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbbA0Jwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:52:38 -0500
Message-ID: <54C75FDB.80805@linn.co.uk>
Date: Tue, 27 Jan 2015 09:52:27 +0000
From: Stathis Voukelatos <stathis.voukelatos@linn.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <abrestic@chromium.org>
Subject: Re: [PATCH] net: Linn Ethernet Packet Sniffer driver
References: <1422007621-13567-1-git-send-email-stathis.voukelatos@linn.co.uk>	 <1422135432.18650.2.camel@perches.com> <54C620CB.3010500@linn.co.uk> <1422301185.18650.4.camel@perches.com>
In-Reply-To: <1422301185.18650.4.camel@perches.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.2.10.219]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26/01/15 19:39, Joe Perches wrote:
> This header file is the public API for the driver.
> Should it not live under the 'include' directory?
> Several other drivers seem to follow that convention.
> It depends on how public is public.
>
> If it's _really_ public, it should be in uapi.
> If it's kinda public, then _maybe_ it should be
> in include/linux, but how likely is it another
> driver will use it?
>
>
It is intended for user space code that needs
to use the driver as it defines the netlink messages and
attributes that the driver understands. So I guess
uapi/linux would be the place for it.

Thanks,
Stathis
