Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352Ab3DBF3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:29:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759996Ab3DBF3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:29:44 -0400
Date: Tue, 2 Apr 2013 10:59:35 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the virtio tree with the rr-fixes
 tree
Message-ID: <20130402052935.GB15084@amit.redhat.com>
References: <20130402141739.0d0b45f519be505a7da471ac@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402141739.0d0b45f519be505a7da471ac@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 02 Apr 2013 [14:17:39], Stephen Rothwell wrote:
> Hi Rusty,
> 
> Today's linux-next merge of the virtio tree got a conflict in
> drivers/char/virtio_console.c between commit 9ba5c80b1aea ("virtio:
> console: add locking around c_ovq operations") from the rr-fixes tree and
> commit 6797999d9958 ("virtio_console: use simplified virtqueue
> accessors") from the virtio tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks OK, just a context change.

Thanks,

		Amit
