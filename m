Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3J3OPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:15:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab3J3OPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:15:46 -0400
Message-ID: <52711481.8030003@redhat.com>
Date: Wed, 30 Oct 2013 15:15:29 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Joe Perches <joe@perches.com>, davem@davemloft.net, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] lib: crc32: clean up spacing in test cases
References: <1383130252-1515-1-git-send-email-dborkman@redhat.com> <1383130252-1515-2-git-send-email-dborkman@redhat.com> <1383141418.12439.76.camel@joe-AO722> <AE90C24D6B3A694183C094C60CF0A2F6026B73C8@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B73C8@saturn3.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 03:10 PM, David Laight wrote:
>>> +	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
>>
>> these could be
>>
>> +	{0x674bf11d, 0x38, 0x542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
>
> Or even:
> #define X(a, b, c, d, e, f) {0x##a, 0x##b, 0x##c, 0x##d, 0x##e. 0x##f}
> 	X(674bf11d, 38, 542, 0af6d466, d8b6e4c1, f6e93d6c),
> ...
> #undef X

Sure, sounds good to me. We could do that as a follow-up.

> 	David
>
>
>
