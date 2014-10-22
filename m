Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbaJVQIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:08:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbaJVQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:08:46 -0400
Message-ID: <5447D68B.6020807@infradead.org>
Date: Wed, 22 Oct 2014 09:08:43 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-media <linux-media@vger.kernel.org>,
        Adams Xu <Adams.xu@azwave.com.cn>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: linux-next: Tree for Oct 22 (media/usb/dvb-usb/az6027)
References: <20141022144243.6ecb1063@canb.auug.org.au>
In-Reply-To: <20141022144243.6ecb1063@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/14 20:42, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20141021:
> 

on x86_64:

when MEDIA_SUBDRV_AUTOSELECT is not enabled:

when DVB_USB_AZ6027=y and DVB_STB0899=m and DVB_STB6100=m:

drivers/built-in.o: In function `az6027_frontend_attach':
az6027.c:(.text+0x18c50d): undefined reference to `stb0899_attach'
az6027.c:(.text+0x18c536): undefined reference to `stb6100_attach'



-- 
~Randy
