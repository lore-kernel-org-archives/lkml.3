Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaAHULk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:11:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40526 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaAHULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:11:38 -0500
Message-ID: <52CDB0CF.5060904@oracle.com>
Date: Wed, 08 Jan 2014 15:10:55 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: increase static allocations
References: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com> <87lhyq45go.fsf@tassilo.jf.intel.com>
In-Reply-To: <87lhyq45go.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 02:51 PM, Andi Kleen wrote:
> Sasha Levin <sasha.levin@oracle.com> writes:
>
>> Fuzzing a recent kernel with a large configuration hits the static
>> allocation limits and disables lockdep.
>
> Doesn't that use a lot more memory?  I thought lockdep preallocates.
>
> Doubling may be too aggressive.

The patch adds about 4MB of memory usage, I didn't think it's too much for something
that is only enabled during debugging.

If this is an issue, can I suggest making these values configurable in the .config
and just let users pick whatever they want?


Thanks,
Sasha

