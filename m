Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab3KOJvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:51:54 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46918 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab3KOJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:51:36 -0500
MIME-Version: 1.0
In-Reply-To: <20131115035918.GA11032@kroah.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com> <20131115035918.GA11032@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Fri, 15 Nov 2013 17:51:14 +0800
Message-ID: <CA+a=Yy5B9o4YUaSkW8sjhfBvn2Ma1J2gvPKWAbda9evR9=qDyg@mail.gmail.com>
Subject: Re: [PATCH 00/40] staging/lustre: patch bomb 1
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:59 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Some of the stuff here looks a lot like "new features / functionality"
> to me, insead of just cleanups and fixes.
>
> Ideally, you all would only work on cleanups and getting this code out
> of staging, and not add new things while it's sitting here.  But I know
> that's going to be hard as you all are still working with an external
> tree.
>
> That external tree is going to be tough to keep up over time, I
> _strongly_ suggest you drop it as soon as possible and only use the
> upstream tree.  Otherwise this whole thing really isn't going to work
> out at all.
>
There are many users of the external tree so we cannot just abandon
it, especially that the upstream client is not shipped in any
distribution yet. Thanks for your understanding.


> I'll go dig through these and see what they look like, thanks...
>
Thanks,
Tao
