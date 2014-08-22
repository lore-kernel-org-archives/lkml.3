Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaHVUFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:05:19 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:40917 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaHVUFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:05:17 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Josef Bacik <jbacik@fb.com>
Cc: Chris Mason <clm@fb.com>, Jiri Kosina <trivial@kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: fs/btrfs/tree-log.c: Fix closing brace followed by if
Organization: D03
References: <1403293903-17696-1-git-send-email-linux@rasmusvillemoes.dk>
	<53A499B8.5050107@fb.com>
X-Hashcash: 1:20:140822:clm@fb.com::H97l/Y58xxFUvX/k:00000000E5F
X-Hashcash: 1:20:140822:linux-btrfs@vger.kernel.org::SjJCGhuMbhIJr1E/:00000000000000000000000000000000000ufu
X-Hashcash: 1:20:140822:jbacik@fb.com::RVYYBKaB0EQHjsVT:00001D8g
X-Hashcash: 1:20:140822:linux-kernel@vger.kernel.org::34zwNZMTxuyp9rN2:0000000000000000000000000000000002+mq
X-Hashcash: 1:20:140822:trivial@kernel.org::nOLU2ulxl7rmmB3T:00000000000000000000000000000000000000000007FWI
Date: Fri, 22 Aug 2014 22:05:13 +0200
In-Reply-To: <53A499B8.5050107@fb.com> (Josef Bacik's message of "Fri, 20 Jun
	2014 13:29:44 -0700")
Message-ID: <87iolkthmu.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josef Bacik <jbacik@fb.com> writes:

> On 06/20/2014 12:51 PM, Rasmus Villemoes wrote:
>> Maybe "else if" was meant, but because of the goto out_unlock, it
>> doesn't make a difference. Anyway, I chose the "only whitespace" fix.
>>
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>>   fs/btrfs/tree-log.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 9e1f2cd..50af2b9 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -3980,7 +3980,8 @@ again:
>>   		if (ret < 0) {
>>   			err = ret;
>>   			goto out_unlock;
>> -		} if (ret) {
>> +		}
>> +		if (ret) {
>>   			ins_nr = 0;
>>   			btrfs_release_path(path);
>>   			continue;
>>
>
> Nope that's right, thanks,
>
> Reviewed-by: Josef Bacik <jbacik@fb.com>

Was this picked up? I don't see it upstream.

Thanks,
Rasmus
