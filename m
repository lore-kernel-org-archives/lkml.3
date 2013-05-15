Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab3EOJrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:47:19 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:49158
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758594Ab3EOJrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:47:17 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zz1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh668h839h947he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1889i1155h)
X-WSS-ID: 0MMU35W-01-3BR-02
X-M-MSG: 
Message-ID: <51935981.3010808@amd.com>
Date: Wed, 15 May 2013 11:46:41 +0200
From: =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <hpa@linux.intel.com>, <yinghai@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: 3.9 breaks EFI boot on E350
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

the following commit breaks booting my E350 based test system in EFI mode:

> commit 8d57470d8f859635deffe3919d7d4867b488b85a
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Fri Nov 16 19:38:58 2012 -0800
>
>     x86, mm: setup page table in top-down

This commit was supposed to fix it but obviously there still seem to be 
some bugs left in 3.9

> commit 98e7a989979b185f49e86ddaed2ad6890299d9f0
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Wed Mar 6 20:18:21 2013 -0800
>
>     x86, mm: Make sure to find a 2M free block for the first mapped area
>
>     Henrik reported that his MacAir 3.1 would not boot with
>
>     | commit 8d57470d8f859635deffe3919d7d4867b488b85a
>     | Date:   Fri Nov 16 19:38:58 2012 -0800
>     |
>     |    x86, mm: setup page table in top-down
>

What do you guys need to debug it?

Cheers,
Christian.

