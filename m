Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaHSNu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:50:28 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:40201 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHSNu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:50:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140819070143.GB12859@ulmo>
References: <20140818153327.GA12278@ulmo> <1408416234-7923-1-git-send-email-mopsfelder@gmail.com>
 <20140819070143.GB12859@ulmo>
From: =?ISO-8859-1?Q?Murilo_Opsfelder_Ara=FAjo?= <mopsfelder@gmail.com>
Date: Tue, 19 Aug 2014 10:49:46 -0300
Message-ID: <CA+LKeY6ZRU3qNza8udpufaEKcrAT-LKmLzcytS=Q=XB=f3Up+Q@mail.gmail.com>
Subject: Re: [PATCH] fs: Initialize mountpoint list head in new_mountpoint()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 4:01 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Aug 18, 2014 at 11:43:54PM -0300, Murilo Opsfelder Araujo wrote:
>> The commit 89f7ca1af15bdfe7a6aed343032a84af2a69f736 makes next-20140818
>> to panic because mountpoint list head was not initialized.  Initializing
>> it with NULL fixes the problem.
>>
>> commit 89f7ca1af15bdfe7a6aed343032a84af2a69f736
>> Author: Eric W. Biederman <ebiederman@twitter.com>
>> Date:   Sun Sep 22 19:37:01 2013 -0700
>>
>>     vfs: Keep a list of mounts on a mount point
>>
>>     To spot any possible problems call BUG if a mountpoint
>>         is put when it's list of mounts is not empty.
>>
>>     AV: use hlist instead of list_head
>>
>> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
>> ---
>>  fs/namespace.c | 1 +
>>  1 file changed, 1 insertion(+)
>
> It's considered good etiquette and polite to credit the original author
> of a patch. This should be:
>
> Originally-by: Thierry Reding <treding@nvidia.com>

(resending to the lists)

Hello, Thierry.

I didn't know about it and you deserve all the credits, for sure.

I'm away from computer today. I'll send a v2 tomorrow night.

-- 
Murilo
