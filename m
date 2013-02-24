Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab3BXWaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:30:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab3BXWae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:30:34 -0500
Date: Mon, 25 Feb 2013 00:30:40 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, sjur.brandeland@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] vringh
Message-ID: <20130224223039.GA5461@redhat.com>
References: <1361226573-12481-1-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361226573-12481-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 08:59:27AM +1030, Rusty Russell wrote:
> This introduces vringh, which are generic accessors for virtio rings (host side).
> There's a host-side implementation in vhost, but it assumes that the rings are
> in userspace, and is tied to the vhost implementation.  I have patches to adapt
> it to use vringh, but I'm pushing this in the next merge window for Sjur, who has
> CAIF patches which need it.
> 
> This also includes a test program in tools/virtio.  There's a fixup patch for
> the current tools, since they didn't compile for me.  MST?
> 
> Review and comments welcome!
> Rusty.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
