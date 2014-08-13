Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaHMQkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:40:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37439 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaHMQkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:40:41 -0400
Message-ID: <53EB9507.3010300@infradead.org>
Date: Wed, 13 Aug 2014 09:40:39 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "m.chehab" <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        Holger Waechtler <holger@convergence.de>,
        Oliver Endriss <o.endriss@gmx.de>
Subject: Re: randconfig build error with next-20140813, in drivers/media/pci/ttpci/av7110_ir.c
References: <CA+r1ZhgkWwnhJYEfm461pesWEMb6rTuYqHtAD5ZZLVm7-_BmCw@mail.gmail.com>
In-Reply-To: <CA+r1ZhgkWwnhJYEfm461pesWEMb6rTuYqHtAD5ZZLVm7-_BmCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/14 09:23, Jim Davis wrote:
> Building with the attached random configuration file,
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `input_sync':
> av7110_ir.c:(.text+0x1223ac): undefined reference to `input_event'
> drivers/built-in.o: In function `av7110_emit_key':
> av7110_ir.c:(.text+0x12247c): undefined reference to `input_event'
> av7110_ir.c:(.text+0x122495): undefined reference to `input_event'
> av7110_ir.c:(.text+0x122569): undefined reference to `input_event'
> av7110_ir.c:(.text+0x1225a7): undefined reference to `input_event'
> drivers/built-in.o:av7110_ir.c:(.text+0x122629): more undefined
> references to `input_event' follow
> drivers/built-in.o: In function `av7110_ir_init':
> (.text+0x1227e4): undefined reference to `input_allocate_device'
> drivers/built-in.o: In function `av7110_ir_init':
> (.text+0x12298f): undefined reference to `input_register_device'
> drivers/built-in.o: In function `av7110_ir_init':
> (.text+0x12299e): undefined reference to `input_free_device'
> drivers/built-in.o: In function `av7110_ir_exit':
> (.text+0x122a94): undefined reference to `input_unregister_device'
> make: *** [vmlinux] Error 1
> 

I reported this on Feb. 14 and July 11 of 2014.  :(


-- 
~Randy
