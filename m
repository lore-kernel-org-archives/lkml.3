Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802Ab3CMP02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:26:28 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55306 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3CMP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:26:27 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAJfpegu40UMTfofY0L20T69sqmPrvpCP53N-xzumgX5MrAZuJw@mail.gmail.com>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
	<CA+icZUVn=3qcEDchYqUf2JqDBfPsN6Zxh+cJCDbUaOrkjg7uJg@mail.gmail.com>
	<CAJfpegu40UMTfofY0L20T69sqmPrvpCP53N-xzumgX5MrAZuJw@mail.gmail.com>
Date: Wed, 13 Mar 2013 16:26:23 +0100
Message-ID: <CA+icZUV=XoN=uUn7npU9Djnkr5DEuA0D42=HV_1n6WN4v2rQMA@mail.gmail.com>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 4:18 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Looks like this is missing (or intended?):
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 482c26f..f23ebfc 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -684,3 +684,6 @@ static void __exit ovl_exit(void)
>>
>>  module_init(ovl_init);
>>  module_exit(ovl_exit);
>> +MODULE_DESCRIPTION("overlayfs v17: provides overlay-filesystem functionality");
>> +MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>> +MODULE_LICENSE("GPL");
>
> No, it *is* already in there.
>

Where is it?

Last lines in [1] are:

685 module_init(ovl_init);
686 module_exit(ovl_exit);

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/mszeredi/vfs.git/tree/fs/overlayfs/super.c?h=overlayfs.current

> Thanks,
> Miklos
