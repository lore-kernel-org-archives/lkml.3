Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3F0I3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:29:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57518 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3F0I3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:29:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen@asianux.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m32r: include: asm: add "dma-mapping-common.h"
Date: Thu, 27 Jun 2013 10:30:51 +0200
Message-ID: <2831217.RWPZkclVnp@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <51CBC4B3.807@asianux.com>
References: <51CBC4B3.807@asianux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:ZwqNtL3YoB8/4I02Zdm05CCxPHeFC4mrk/S7opSC6wr
 V4pUbcjUQgm35crahZiBfGzu7zEznML64wElarH5w8JySeH+A6
 uxmTyPB6Td+OnnQlTWRSgeQWzVVZjQyf0E6wfUs58TbqQswgkp
 cPi5e1HpDhPe6+C15m+PAX3bFysvydoxqGi1ZGAc/zHvjd5NGL
 /aOO04W6SoxGYjaAqqwGSScTvvbeTnU8qfwxKCmTXK5FP34KY/
 uFgW5Rbg4ivHJei2gmNM0TuUwAIhufmOyImou1VOJq/sob9HyQ
 rO3i0Pqvh1lvy33uQ/iVwPFUHsKyYf3pukAX4VRc3gYvTjXmg6
 zlmXpwzgXVjDgqusrNFk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 June 2013 12:50:59 Chen Gang wrote:
> Need add generic "dma-mapping-common.h", or compiling may fail.
> 
> The related error (with allmodconfig):
> 
>     CC [M]  net/irda/irlan/irlan_eth.o
>   drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
>   drivers/media/v4l2-core/videobuf2-dma-contig.c:202:2: error: implicit declaration of function ‘dma_mmap_coherent’ [-Werror=implicit-function-declaration]
>   drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
>   drivers/media/v4l2-core/videobuf2-dma-contig.c:385:2: error: implicit declaration of function ‘dma_get_sgtable’ [-Werror=implicit-function-declaration]
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

m32r does not provide the "common" version of the dma mapping API, so this
is certainly wrong.

	Arnd
