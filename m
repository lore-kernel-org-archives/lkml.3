Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3F0Jla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:41:30 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28044 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3F0Jl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:41:27 -0400
X-Spam-Score: -100.9
Message-ID: <51CC0891.9050704@asianux.com>
Date: Thu, 27 Jun 2013 17:40:33 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Hirokazu Takata <takata@linux-m32r.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m32r: include: asm: add "dma-mapping-common.h"
References: <51CBC4B3.807@asianux.com> <2831217.RWPZkclVnp@wuerfel> <51CC0598.2080409@asianux.com>
In-Reply-To: <51CC0598.2080409@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 05:27 PM, Chen Gang wrote:
> On 06/27/2013 04:30 PM, Arnd Bergmann wrote:
>> > On Thursday 27 June 2013 12:50:59 Chen Gang wrote:
>>> >> Need add generic "dma-mapping-common.h", or compiling may fail.
>>> >>
>>> >> The related error (with allmodconfig):
>>> >>
>>> >>     CC [M]  net/irda/irlan/irlan_eth.o
>>> >>   drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
>>> >>   drivers/media/v4l2-core/videobuf2-dma-contig.c:202:2: error: implicit declaration of function ‘dma_mmap_coherent’ [-Werror=implicit-function-declaration]
>>> >>   drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
>>> >>   drivers/media/v4l2-core/videobuf2-dma-contig.c:385:2: error: implicit declaration of function ‘dma_get_sgtable’ [-Werror=implicit-function-declaration]
>>> >>
>>> >>
>>> >> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > 
>> > m32r does not provide the "common" version of the dma mapping API, so this
>> > is certainly wrong.
>> > 

Oh, sorry, the reply below is incorrect, I will check it, again, thanks.

> But m32r really has pci.h, and also can cause this issue.


-- 
Chen Gang
