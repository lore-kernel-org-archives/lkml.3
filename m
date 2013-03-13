Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775Ab3CMUwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:52:44 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44954 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMUwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:52:41 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130313200542.GN21522@ZenIV.linux.org.uk>
References: <1363204034-2442-1-git-send-email-sedat.dilek@gmail.com>
	<20130313200542.GN21522@ZenIV.linux.org.uk>
Date: Wed, 13 Mar 2013 21:52:39 +0100
Message-ID: <CA+icZUX3WJYGvd-trCBcOd63CVSnECi5NA5_g_toVms8KNhq-Q@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: Print info into the logs when loaded
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 9:05 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Mar 13, 2013 at 08:47:14PM +0100, Sedat Dilek wrote:
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>> ---
>>  fs/overlayfs/super.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 482c26f..e30141f 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -674,6 +674,8 @@ MODULE_ALIAS_FS("overlayfs");
>>
>>  static int __init ovl_init(void)
>>  {
>> +     printk(KERN_INFO "overlayfs: loaded\n");
>> +
>
> Could we please create a new maillist for that kind of stuff?  It's seriously
> overdue, IMO.  linux-bikeshedding@vger.kernel.org, if davem doesn't mind
> touching that...

Dear Mr. Viro,

I looked over fs/ especially in concerńs of status-informations - I
had better not done it.
This remembered me the crap with drm/kms with all its useless driver info.

Here for you:

[   10.998890] [drm] Initialized drm 1.1.0 20060810
[   13.147821] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

( On a quick Google search I found [1] (I rememebr there were 4
patches but break user-space as there exists kernel-drm and libdrm). )

As an enduser I want some useful help.

As a non-native English I had to look up that "bikeshedding" word.
People asked for review why not test it and give feedback - even
report on useless stuff seen from your POV.
This might be a little detail in your eyes - but you are free to have
a deeper look on overlayfs as an filesystem-expert.
For me it is important that this drama comes to an end.
O.O. drama - isn't someone dying in the end :-).
Take it with British humour :-).

- Sedat -

[1] https://lkml.org/lkml/2010/12/22/50
