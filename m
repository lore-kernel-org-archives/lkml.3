Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765410Ab3DDWy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:54:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765052Ab3DDWy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:54:27 -0400
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] BLOCK: rbd, return proper error from rbd_dev_probe_update_spec
References: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
Date: Fri, 05 Apr 2013 00:53:40 +0200
In-Reply-To: <1365107532-32721-1-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Thu, 4 Apr 2013 22:32:08 +0200")
Message-ID: <m3a9pdvrez.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> ret might be uninitialized and is returned that way when kstrdup of
> rbd_dev->spec->snap_name fails. Fix it by returning ENOMEM from that
> place.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/block/rbd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Acked-by: Nikola Pajkovsky <npajkovs@redhat.com>

-- 
Nikola
