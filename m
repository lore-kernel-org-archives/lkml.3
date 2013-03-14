Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab3CNNf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:35:59 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:42853 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab3CNNf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:35:57 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130313160623.52ec76cd5239c791b59828b8@linux-foundation.org>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-9-git-send-email-miklos@szeredi.hu>
	<20130313160623.52ec76cd5239c791b59828b8@linux-foundation.org>
Date: Thu, 14 Mar 2013 14:35:54 +0100
Message-ID: <CAJfpegvfsG1G6LDNuYdvH-d_pGXx4hq6qS4WfVHhj27cbdHj9w@mail.gmail.com>
Subject: Re: [PATCH 8/9] overlay: overlay filesystem documentation
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:06 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 13 Mar 2013 15:16:32 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> From: Neil Brown <neilb@suse.de>
>>
>> Document the overlay filesystem.
>>
>
> Damn, I did it again.  This is good, thanks.
>
>> +Changes to the underlying filesystems while part of a mounted overlay
>> +filesystem are not allowed.  If the underlying filesystem is changed,
>> +the behavior of the overlay is undefined, though it will not result in
>> +a crash or deadlock.
>
> ah-hah, there it is.  I was wondering how this can-o-worms would be
> handled ;)
>
> Is there anything in place to enforce this at runtime?  Checks for
> read-onlyness, code to prevent rw remounts, etc?

No, currently it is not enforced.  I didn't think this was important
enough, and there was no complaint about this from users.  I think
most people are going to be careful, especially if lots of warnings
are given in the documentation.

Thanks,
Miklos
