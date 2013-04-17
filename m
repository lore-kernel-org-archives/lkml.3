Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966126Ab3DQUmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:42:32 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:54506 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965571Ab3DQUma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:42:30 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <50D02550.3090903@parallels.com>
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
	<20121214152113.27155.58793.stgit@maximpc.sw.ru>
	<50CB8931.2000305@redhat.com>
	<50CF288E.8060002@parallels.com>
	<50CF6CB6.5030703@redhat.com>
	<50D02550.3090903@parallels.com>
Date: Wed, 17 Apr 2013 22:42:28 +0200
Message-ID: <CAJfpegsoqWv2eMQ1hxmvaUKzbQHGepnyeiUUGB6u+NJRj0h4Gg@mail.gmail.com>
Subject: Re: [PATCH 5/6] fuse: truncate file if async dio failed
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
Cc: Brian Foster <bfoster@redhat.com>, Kirill Korotaev <dev@parallels.com>,
        Pavel Emelianov <xemul@parallels.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 9:12 AM, Maxim V. Patlasov
<mpatlasov@parallels.com> wrote:
> I did exactly the same before sending previous email :) In my tests it works
> as expected too (modulo fuse_allow_task() that we can move up). I'll re-send
> corrected patch soon.

This patch was not yet re-sent.  I applied the rest of them in this
series (with small changes) and pushed to for-next.

Thanks,
Miklos
