Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3BEKIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:08:20 -0500
Received: from multi.imgtec.com ([194.200.65.239]:27339 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab3BEKIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:08:14 -0500
Message-ID: <5110DA06.1000804@imgtec.com>
Date: Tue, 5 Feb 2013 10:08:06 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
        <linux-mm@kvack.org>, Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: next-20130204 - bisected slab problem to "slab: Common constants
 for kmalloc boundaries"
References: <510FE051.7080107@imgtec.com> <0000013ca6a87485-3f013e82-046c-4374-86d5-67fb85a085f9-000000@email.amazonses.com>
In-Reply-To: <0000013ca6a87485-3f013e82-046c-4374-86d5-67fb85a085f9-000000@email.amazonses.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_05_10_08_08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/13 19:22, Christoph Lameter wrote:
> On Mon, 4 Feb 2013, James Hogan wrote:
> 
>> I've hit boot problems in next-20130204 on Meta:
> 
> Meta is an arch that is not in the tree yet? How would I build for meta?

Yes (well, it's in -next now, so merging the for-next branch of
git://github.com/jahogan/metag-linux.git would add Meta support, which
at the point of your commit produces no conflicts).

It sounds like Stephen Warren has hit the same problem (in the
configuration I'm using ARCH_DMA_MINALIGN was also 64, but in another
configuration that worked, ARCH_DMA_MINALIGN was 8 (see
arch/metag/include/asm/cache.h).

For the record though, to cross compile, you'd need to build a
meta2_defconfig of the buildroot at
git://github.com/img-meta/metag-buildroot.git.

Cheers
James

