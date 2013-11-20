Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3KTSeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:34:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51253 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KTSeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:34:06 -0500
Message-ID: <528D009C.8020507@infradead.org>
Date: Wed, 20 Nov 2013 10:34:04 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Nov 20 (usb/gadget/storage_common.c)
References: <20131120132847.9321fab265bc5cb0a117c61e@canb.auug.org.au>
In-Reply-To: <20131120132847.9321fab265bc5cb0a117c61e@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/13 18:28, Stephen Rothwell wrote:
> Hi all,
> 
> Please do *not* add any v3.14 material to linux-next until after
> v3.13-rc1 is released.
> 
> Changes since 20131119:
> 

on x86_64:
when CONFIG_BLOCK is not enabled:

drivers/usb/gadget/storage_common.c: In function 'fsg_lun_open':
drivers/usb/gadget/storage_common.c:241:3: error: implicit declaration of function 'bdev_logical_block_size' [-Werror=implicit-function-declaration]
drivers/usb/gadget/storage_common.c:242:3: error: implicit declaration of function 'blksize_bits' [-Werror=implicit-function-declaration]



-- 
~Randy
