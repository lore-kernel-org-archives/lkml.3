Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbbASHmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:42:09 -0500
Received: from ozlabs.org ([103.22.144.67]:39711 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbbASHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:42:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_pci: add module param to force legacy mode
In-Reply-To: <1421337370-25961-1-git-send-email-mst@redhat.com>
References: <1421337370-25961-1-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 Jan 2015 16:23:36 +1030
Message-ID: <8761c3co4f.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> If set, try legacy interface first, modern one if that fails.  Useful to
> work around device/driver bugs, and for compatibility testing.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Thanks, I've applied all these to virtio-next.

Cheers!
Rusty.
