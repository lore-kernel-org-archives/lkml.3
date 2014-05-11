Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaEKRrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 13:47:55 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:48714 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaEKRrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 13:47:52 -0400
Message-ID: <536FB7C4.4060803@gmail.com>
Date: Sun, 11 May 2014 19:47:48 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [BUG] sched_setattr() SCHED_DEADLINE hangs system
References: <536F8F0E.7020301@gmail.com>
In-Reply-To: <536F8F0E.7020301@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 04:54 PM, Michael Kerrisk (man-pages) wrote:
> $ time sudo ./t_sched_setattr d 18446744072 18446744072 18446744073
> 
> 'd' here means use SCHED_DEADLINE, then the remaining arguments
> are the Runtime, Deadline, and Period, expressed in *seconds*.
> (Those number by the way are just a little below 2^64.)

I wasn't being 100% clear there. I mean to say: Those numbers are,
when converted to nanoseconds, just a little below 2^64.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
