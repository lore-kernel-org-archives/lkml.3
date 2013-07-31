Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab3GaGso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:48:44 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:64103 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab3GaGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:48:42 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Date: Wed, 31 Jul 2013 08:48:40 +0200
Message-ID: <CA+icZUX7aFAPBo_nhBLQ7-F465_Bujg5Cr5+xL+hfcwn6BMo=Q@mail.gmail.com>
Subject: Re: [PATCH 00/11] Sync and VFS scalability improvements
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        jack@suse.cz, glommer@parallels.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 6:15 AM, Dave Chinner <david@fromorbit.com> wrote:
> Hi folks,
>
> This series of patches is against the curent mmotm tree here:
>
> http://git.cmpxchg.org/cgit/linux-mmotm.git/
>

"Current" is not precise enough... above tree has git-tags.
I guess you mean "v3.11-rc1-mmotm-2013-07-18-16-40" ?

As I am not a linux-fs expert I can try to test, preferably against a
Linux-next release.
Would you like to test against "vanilla" mmotm or is Linux-next
suitable in your eyes?

I have seen some typos... are you interested in such feedback?

- Sedat -

[1] http://git.cmpxchg.org/cgit/linux-mmotm.git/tag/?id=v3.11-rc1-mmotm-2013-07-18-16-40
