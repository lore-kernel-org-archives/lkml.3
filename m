Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab3CRViJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:38:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34158 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3CRViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:38:04 -0400
Message-ID: <51478949.2080400@infradead.org>
Date: Mon, 18 Mar 2013 14:38:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: Re: linux-next: Tree for Mar 18 (mtdcore)
References: <20130318161841.a8f926f51a0b00033e2ee94c@canb.auug.org.au>
In-Reply-To: <20130318161841.a8f926f51a0b00033e2ee94c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/13 22:18, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130315:
> 


when CONFIG_PROC_FS is not enabled:

  CC [M]  drivers/mtd/mtdcore.o
drivers/mtd/mtdcore.c: In function 'init_mtd':
drivers/mtd/mtdcore.c:1183:2: error: 'proc_mtd' undeclared (first use in this function)
drivers/mtd/mtdcore.c:1183:2: note: each undeclared identifier is reported only once for each function it appears in
drivers/mtd/mtdcore.c: In function 'cleanup_mtd':
drivers/mtd/mtdcore.c:1208:2: error: 'proc_mtd' undeclared (first use in this function)
make[3]: *** [drivers/mtd/mtdcore.o] Error 1



-- 
~Randy
