Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3H1Bk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:40:26 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43521 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3H1BkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:40:24 -0400
Date: Tue, 27 Aug 2013 18:35:38 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] power/reset: Make vexpress driver depend on required
 infrastructure
Message-ID: <20130828013538.GF10506@lizard>
References: <20130815114401.GD23006@n2100.arm.linux.org.uk>
 <1376580952-21677-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376580952-21677-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 04:35:52PM +0100, Pawel Moll wrote:
> ARM Versatile Express reset driver requires platform-specific
> config infrastructure to be present in the kernel. When
> VEXPRESS_CONFIG is not selected, the build will fail like this:
> 
> drivers/built-in.o: In function `vexpress_reset_do.clone.0':
> iio-trig-interrupt.c:(.text+0x1aff38): undefined reference to `__vexpress_config_func_get'
> iio-trig-interrupt.c:(.text+0x1aff4c): undefined reference to `vexpress_config_write'
> 
> Added required dependency to the Kconfig entry.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Applied, thanks!

Anton
