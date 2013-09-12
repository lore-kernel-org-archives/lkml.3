Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab3ILSOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:14:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54586 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab3ILSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:14:00 -0400
Message-ID: <52320465.9000201@infradead.org>
Date: Thu, 12 Sep 2013 11:13:57 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gordoni Waidhofer <gwaidhofer@stec-inc.com>,
        Thomas Swann <tswann@stec-inc.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>
Subject: Re: linux-next: Tree for Sep 12 (block/skd_main.c)
References: <20130912143402.73f77e0cef1e19576b77a6b5@canb.auug.org.au>
In-Reply-To: <20130912143402.73f77e0cef1e19576b77a6b5@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/13 21:34, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any code for v3.13 to your linux-next included branches
> until after v3.12-rc1 is released.
> 
> Changes since 20130911:
> 


on i386 (32-bit):

drivers/block/skd_main.c: In function 'skd_reg_write64':
drivers/block/skd_main.c:439:3: error: implicit declaration of function 'writeq' [-Werror=implicit-function-declaration]
drivers/block/skd_main.c:441:3: error: implicit declaration of function 'readq' [-Werror=implicit-function-declaration]
drivers/block/skd_main.c: In function 'skd_preop_sg_list_blk':
drivers/block/skd_main.c:1104:3: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]
drivers/block/skd_main.c: In function 'skd_end_request_bio':
drivers/block/skd_main.c:1155:7: warning: unused variable 'cpu' [-Wunused-variable]
drivers/block/skd_main.c: In function 'skd_preop_sg_list_bio':
drivers/block/skd_main.c:1240:3: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]
drivers/block/skd_main.c: In function 'skd_skreq_prep_buffering':
drivers/block/skd_main.c:1920:3: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]
drivers/block/skd_main.c: In function 'skd_send_fitmsg':
drivers/block/skd_main.c:2470:2: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat]
drivers/block/skd_main.c: In function 'skd_send_special_fitmsg':
drivers/block/skd_main.c:2532:3: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat]
drivers/block/skd_main.c: In function 'skd_cons_skmsg':
drivers/block/skd_main.c:4565:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Wformat]
drivers/block/skd_main.c:4595:25: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/block/skd_main.c:4598:27: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/block/skd_main.c:4598:20: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
drivers/block/skd_main.c: In function 'skd_cons_skreq':
drivers/block/skd_main.c:4620:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Wformat]
drivers/block/skd_main.c:4620:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat]
drivers/block/skd_main.c:4632:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Wformat]
drivers/block/skd_main.c:4632:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat]
drivers/block/skd_main.c: In function 'skd_cons_skspcl':
drivers/block/skd_main.c:4677:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Wformat]
drivers/block/skd_main.c:4677:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat]




-- 
~Randy
