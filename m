Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3BSIKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:10:52 -0500
Received: from ozlabs.org ([203.10.76.45]:39706 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758101Ab3BSICm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Cc: sjur.brandeland@stericsson.com, mst@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] vringh
Date: Tue, 19 Feb 2013 08:59:27 +1030
Message-Id: <1361226573-12481-1-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces vringh, which are generic accessors for virtio rings (host side).
There's a host-side implementation in vhost, but it assumes that the rings are
in userspace, and is tied to the vhost implementation.  I have patches to adapt
it to use vringh, but I'm pushing this in the next merge window for Sjur, who has
CAIF patches which need it.

This also includes a test program in tools/virtio.  There's a fixup patch for
the current tools, since they didn't compile for me.  MST?

Review and comments welcome!
Rusty.

