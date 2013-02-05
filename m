Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3BEMxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:53:19 -0500
Received: from multi.imgtec.com ([194.200.65.239]:40898 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab3BEMxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:53:18 -0500
Message-ID: <5111006A.4070809@imgtec.com>
Date: Tue, 5 Feb 2013 12:51:54 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
        <linux-mm@kvack.org>
Subject: Re: next-20130204 - bisected slab problem to "slab: Common constants
 for kmalloc boundaries"
References: <510FE051.7080107@imgtec.com> <0000013ca6a87485-3f013e82-046c-4374-86d5-67fb85a085f9-000000@email.amazonses.com>
In-Reply-To: <0000013ca6a87485-3f013e82-046c-4374-86d5-67fb85a085f9-000000@email.amazonses.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_05_12_53_15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 04/02/13 19:22, Christoph Lameter wrote:
> What are the values of
> 
> MAX_ORDER

10

> PAGE_SHIFT

12

> ARCH_DMA_MINALIGN

64 (it works if changed to 8)

> CONFIG_ZONE_DMA

not defined

Cheers
James

