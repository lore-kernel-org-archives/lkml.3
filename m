Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaLHNWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:22:55 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:55680 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLHNWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:22:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, broonie@kernel.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/4] spi: st: New driver for ST's SPI Controller
Date: Mon, 08 Dec 2014 14:22:11 +0100
Message-ID: <11694915.sCOqLZA7N1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418043214-14324-1-git-send-email-lee.jones@linaro.org>
References: <1418043214-14324-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:orJwc0eIo3STO5LghDLRxzzd/P+poy/jpdB4z8l0zhWjDdXp1O/
 M/xj22A2sn9Y4wUXNTyaAc0TuBKx2gDBpmdFmA0rok+KEJqUKyZlwmdFszQ0QWDbZMgvjHj
 pASgIALoFBfYeYnyShvubp99GSdo/9QQ3OgCBekPdilvEjHQsF6cdb46UdYxtaMM/2285qk
 IvdKftpOaO18AUYs4foxg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 12:53:30 Lee Jones wrote:
> This is a new driver which controls the SPI component of ST's
> Synchronous Serial Controller (SSC).
> 

How does this related to the i2c driver for drivers/i2c/busses/i2c-st.c?
Could you have the same piece of hardware do one or the other mode
depending on pin configuration, or is each instance hardwired to
a particular mode?

Is there any code worth sharing between the two drivers?

	Arnd
