Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaESBnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:43:49 -0400
Received: from ozlabs.org ([103.22.144.67]:33508 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaESBnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:43:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Amos Kong <akong@redhat.com>, linux-kernel@vger.kernel.org
Cc: "Sasha Levin" <sasha.levin@oracle.com>
Subject: Re: [PATCH 1/2] virtio-rng: cope if struct hwrng.name is changed to const
In-Reply-To: <20140515153140.49b8028b@canb.auug.org.au>
References: <20140515153140.49b8028b@canb.auug.org.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 May 2014 09:30:53 +0930
Message-ID: <87zjiek56y.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/char/hw_random/virtio-rng.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> Based on the current virtio tree in linux-next.

Actually, Sasha Levin did a nice cleanup which replaces these two,
and restores the const.

I've applied them, so you should have it in today's linux-next.

Thanks,
Rusty.
