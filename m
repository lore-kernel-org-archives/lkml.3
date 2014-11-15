Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363AbaKODEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 22:04:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21737 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaKODEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 22:04:37 -0500
Message-ID: <5466C2B9.9070200@oracle.com>
Date: Fri, 14 Nov 2014 22:04:25 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
CC: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
        kirill@shutemov.name, Alexander Viro <viro@zeniv.linux.org.uk>,
        pinskia@gmail.com, joe@perches.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: use the gnu89 standard explicitly
References: <1413772855-8613-1-git-send-email-sasha.levin@oracle.com> <CAPAsAGwFzwqVW1y_A76q68uDAMFm-yWjTtJtXUprOWaEifS2uQ@mail.gmail.com>
In-Reply-To: <CAPAsAGwFzwqVW1y_A76q68uDAMFm-yWjTtJtXUprOWaEifS2uQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 08:43 AM, Andrey Ryabinin wrote:
> 2014-10-20 5:40 GMT+03:00 Sasha Levin <sasha.levin@oracle.com>:
>> gcc5 changes the default standard to c11, which makes kernel
>> build unhappy.
>>
>> Explicitly define the kernel standard to be gnu89 which should
>> keep everything working exactly like it was before gcc5.
>>
> 
> Ping.
> 

fwiw, I'm happy with using Kirill's patch from this thread, it
even has his SoB! :)

Thanks,
Sasha
