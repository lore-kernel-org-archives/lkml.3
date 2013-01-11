Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3AKQEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:04:43 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35421 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab3AKQEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:04:42 -0500
Message-ID: <50F037F2.8040301@linux.vnet.ibm.com>
Date: Fri, 11 Jan 2013 08:04:02 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: paul.szabo@sydney.edu.au
CC: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] Reproducible OOM with partial workaround
References: <201301110146.r0B1kF4T032208@como.maths.usyd.edu.au>
In-Reply-To: <201301110146.r0B1kF4T032208@como.maths.usyd.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011116-5806-0000-0000-00001E1D1AE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 05:46 PM, paul.szabo@sydney.edu.au wrote:
>> > ... I don't believe 64GB of RAM has _ever_ been booted on a 32-bit
>> > kernel without either violating the ABI (3GB/1GB split) or doing
>> > something that never got merged upstream ...
> Sorry to be so contradictory:
> 
> psz@como:~$ uname -a
> Linux como.maths.usyd.edu.au 3.2.32-pk06.10-t01-i386 #1 SMP Sat Jan 5 18:34:25 EST 2013 i686 GNU/Linux
> psz@como:~$ free -l
>              total       used       free     shared    buffers     cached
> Mem:      64446900    4729292   59717608          0      15972     480520
> Low:        375836     304400      71436
> High:     64071064    4424892   59646172
> -/+ buffers/cache:    4232800   60214100
> Swap:    134217724          0  134217724

Hey, that's pretty cool!  I would swear that the mem_map[] overhead was
such that they wouldn't boot, but perhaps those brain cells died on me.



