Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3G3IEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:04:14 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:56615 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab3G3IEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:04:04 -0400
Message-ID: <51F7736C.5040701@gmail.com>
Date: Tue, 30 Jul 2013 10:03:56 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: dove: add initial DT file for Globalscale D2Plug
References: <1375100946-28521-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375100946-28521-5-git-send-email-sebastian.hesselbarth@gmail.com> <20130729184520.GI24782@lunn.ch>
In-Reply-To: <20130729184520.GI24782@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 08:45 PM, Andrew Lunn wrote:
> On Mon, Jul 29, 2013 at 02:29:06PM +0200, Sebastian Hesselbarth wrote:
>> This adds an initial DT file for the Globalscale D2Plug with Dove SoC.
>> Currently, one LED is missing and I have not been able to get SD8787 driver
>> working. Those will be taken care of later.
>
> I took a hard look at SDIO and failed to get it working when doing
> DMA. Polled IO does however work. I guess we need some help from
> Marvell engineers before we get stable SDIO with DMA.

Andrew,

have you tried this on the Dove D2Plug or any other Marvell SoC?
Dove is using a different SDHCI compatible SDIO controller.

Anyway, I haven't had a deep look into neither SDIO/SDHCI DMA nor
sd8787 driver.

Also, the DMA issue is not holding back this patch, is it?

Sebastian

