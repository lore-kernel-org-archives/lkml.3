Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3BRVm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 16:42:58 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:43250 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab3BRVm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 16:42:57 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <510973C8.1090209@oracle.com>
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
	<x49obg7omos.fsf@segfault.boston.devel.redhat.com>
	<510891ED.8090404@oracle.com>
	<x49d2wmqxui.fsf@segfault.boston.devel.redhat.com>
	<510973C8.1090209@oracle.com>
Date: Mon, 18 Feb 2013 22:42:55 +0100
Message-ID: <CA+icZUXG4xnGFC=R4nLJbtC2y5AD4Q_CvX1Q3SmGsT0W_7ZMUA@mail.gmail.com>
Subject: Re: [PATCH V6 00/30] loop: Issue O_DIRECT aio using bio_vec
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 8:26 PM, Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
> By the way, I have updated the patchset in git. I removed the version
> from the name of the branch and will keep this one updated:
>
> git://github.com/kleikamp/linux-shaggy.git aio_loop

What's the status of this patchset?
Will it go into Linux-Next? Through Al's VFS tree? Any chance to have
it for-3.9?

- Sedat -

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
