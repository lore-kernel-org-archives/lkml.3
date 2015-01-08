Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbbAHQia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:38:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbbAHQi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:38:28 -0500
Message-ID: <54AEB25E.9050205@redhat.com>
Date: Thu, 08 Jan 2015 10:37:50 -0600
From: Mark Langsdorf <mlangsdo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Linux 3.19-rc3
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com> <54AE7D53.2020305@redhat.com> <20150108150850.GD5658@dhcp22.suse.cz>
In-Reply-To: <20150108150850.GD5658@dhcp22.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 09:08 AM, Michal Hocko wrote:
> [CCing linux-mm and CMA people]
> [Full message here:
> http://article.gmane.org/gmane.linux.ports.arm.kernel/383669]

>> [ 1054.095277] DMA: 109*64kB (UR) 53*128kB (R) 8*256kB (R) 0*512kB 0*1024kB
>> 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R) 0*65536kB = 52672kB
>> [ 1054.108621] Normal: 191*64kB (MR) 0*128kB 0*256kB 0*512kB 0*1024kB
>> 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 12224kB
> [...]
>> [ 1054.142545] Free swap  = 6598400kB
>> [ 1054.145928] Total swap = 8388544kB
>> [ 1054.149317] 262112 pages RAM
>> [ 1054.152180] 0 pages HighMem/MovableOnly
>> [ 1054.155995] 18446744073709544361 pages reserved
>> [ 1054.160505] 8192 pages cma reserved
>
> Besides underflow in the reserved pages accounting mentioned in other
> email the free lists look strange as well. All free blocks with some memory
> are marked as reserved. I would suspect something CMA related.

I get the same failure with CMA turned off entirely. I assume that means
CMA is not the culprit.

--Mark Langsdorf

