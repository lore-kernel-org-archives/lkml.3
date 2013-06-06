Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3FFSun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:50:43 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:41535 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3FFSul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:50:41 -0400
MIME-Version: 1.0
In-Reply-To: <1370521145-9723-1-git-send-email-mst@redhat.com>
References: <1370521145-9723-1-git-send-email-mst@redhat.com>
Date: Thu, 6 Jun 2013 21:50:40 +0300
Message-ID: <CA+ydwto07+r2KxGAE=fnBUjs1_hz9CFFJwQrpE0TmAnCu0f8FA@mail.gmail.com>
Subject: Re: [PATCH net 0/2] vhost fixes for 3.10
From: Tommi Rantala <tt.rantala@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, Asias He <asias@redhat.com>,
        David Miller <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/6 Michael S. Tsirkin <mst@redhat.com>:
> Two patches fixing the fallout from the vhost cleanup in 3.10.
> Thanks to Tommi Rantala who reported the issue.
>
> Tommi, could you please confirm this fixes the crashes for you?

Confirmed! With the two patches applied, I can no longer reproduce the
crash with trinity.

Thanks!

Tommi

> Michael S. Tsirkin (2):
>   vhost: check owner before we overwrite ubuf_info
>   vhost: fix ubuf_info cleanup
>
>  drivers/vhost/net.c   | 26 +++++++++++---------------
>  drivers/vhost/vhost.c |  8 +++++++-
>  drivers/vhost/vhost.h |  1 +
>  3 files changed, 19 insertions(+), 16 deletions(-)
>
> --
> MST
>
