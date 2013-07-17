Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3GQNEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:04:51 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:50359 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3GQNEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:04:50 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20130717112009.GU18803@ndevos-laptop.usersys.redhat.com>
References: <1373893160-30601-1-git-send-email-ndevos@redhat.com>
	<51E456B6.8050601@redhat.com>
	<20130716103939.GL18803@ndevos-laptop.usersys.redhat.com>
	<51E54764.4070106@redhat.com>
	<20130716161458.GA19664@tucsk.piliscsaba.szeredi.hu>
	<20130717112009.GU18803@ndevos-laptop.usersys.redhat.com>
Date: Wed, 17 Jul 2013 15:04:49 +0200
Message-ID: <CAJfpegue8zVwLM3TO3fU6h2kHZRJRLpGXft10n5Dv+7UZWZ2oA@mail.gmail.com>
Subject: Re: [fuse-devel] [PATCH] fuse: fix occasional dentry leak when
 readdirplus is used
From: Miklos Szeredi <miklos@szeredi.hu>
To: Niels de Vos <ndevos@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 1:20 PM, Niels de Vos <ndevos@redhat.com> wrote:
> I can confirm that your patch fixes the original panic/BUG() with both
> Brian's test-case and the GlusterFS regression tests.
>
> Feel free to add my Tested-by/Reviewed-by signoff for this patch.

Thanks for the review and testing, patches pushed to

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-next

Thanks,
Miklos
