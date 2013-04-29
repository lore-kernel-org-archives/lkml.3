Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3D2Q0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:26:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:57558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3D2Q0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:26:20 -0400
Message-ID: <517E9F12.1020309@infradead.org>
Date: Mon, 29 Apr 2013 09:25:54 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 29 (kconfig)
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
In-Reply-To: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/13 02:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130426:
> 


> make ARCH=x86_64 O=X64 xconfig &
  GEN     /local/lnx/next/linux-next-20130429/X64/Makefile
  HOSTCXX scripts/kconfig/qconf.o
In file included from scripts/kconfig/expr.h:15:0,
                 from scripts/kconfig/lkc.h:9,
                 from scripts/kconfig/qconf.cc:46:
scripts/kconfig/list.h: In function 'void list_del(list_head*)':
scripts/kconfig/list.h:128:16: error: invalid conversion from 'void*' to 'list_head*' [-fpermissive]
scripts/kconfig/list.h:129:16: error: invalid conversion from 'void*' to 'list_head*' [-fpermissive]
make[2]: *** [scripts/kconfig/qconf.o] Error 1



-- 
~Randy
