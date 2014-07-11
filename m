Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbaGKSbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:31:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36644 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaGKSbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:31:22 -0400
Message-ID: <53C02D77.4070809@infradead.org>
Date: Fri, 11 Jul 2014 11:31:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Holger Waechtler <holger@convergence.de>,
        Oliver Endriss <o.endriss@gmx.de>
Subject: Re: linux-next: Tree for Jul 11 (media/pci/ttpci/av7110)
References: <20140711171844.39fcbb50@canb.auug.org.au>
In-Reply-To: <20140711171844.39fcbb50@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/14 00:18, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140710:
> 

on x86_64:

CONFIG_DVB_AV7110=y
CONFIG_INPUT_EVDEV=m

drivers/built-in.o: In function `av7110_emit_keyup':
av7110_ir.c:(.text+0x76b608): undefined reference to `input_event'
av7110_ir.c:(.text+0x76b61a): undefined reference to `input_event'
drivers/built-in.o: In function `av7110_emit_key':
av7110_ir.c:(.text+0x76b6b4): undefined reference to `input_event'
av7110_ir.c:(.text+0x76b6cd): undefined reference to `input_event'
av7110_ir.c:(.text+0x76b7b0): undefined reference to `input_event'
drivers/built-in.o:av7110_ir.c:(.text+0x76b7ca): more undefined references to `input_event' follow
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x76bcdb): undefined reference to `input_allocate_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x76bf93): undefined reference to `input_register_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x76c073): undefined reference to `input_free_device'
drivers/built-in.o: In function `av7110_ir_exit':
(.text+0x76c1db): undefined reference to `input_unregister_device'


-- 
~Randy
