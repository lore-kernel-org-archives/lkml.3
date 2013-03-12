Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab3CLUBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:01:49 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:43955 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab3CLUBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:01:47 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <9427.1363108933@jrobl>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
	<9427.1363108933@jrobl>
Date: Tue, 12 Mar 2013 21:01:45 +0100
Message-ID: <CAJfpegvFGaN4udS6O7_=FnWrO6tUSmNMasddWAChxHhS08yBdQ@mail.gmail.com>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 6:22 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Miklos Szeredi:
>> Please consider overlayfs for inclusion into 3.10.
>
> Thank you for CCing me.
>
> First, I'd suggest you to follow some recent activities in mainline
> kernel such as
> - MODULE_ALIAS_FS
> - file_inode()

Okay, thanks for the comments.  Will fix.

Miklos
