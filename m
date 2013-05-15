Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3EOFVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 01:21:04 -0400
Received: from ozlabs.org ([203.10.76.45]:33336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab3EOFU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 01:20:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, Asias He <asias@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, <netdev@vger.kernel.org>
Subject: Re: [PATCH] vhost-scsi: Depend on NET for memcpy_fromiovec
In-Reply-To: <1368579583-13097-1-git-send-email-asias@redhat.com>
References: <20130515095558.918f2b29ba318a477eb5dde2@canb.auug.org.au> <1368579583-13097-1-git-send-email-asias@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 15 May 2013 14:47:53 +0930
Message-ID: <8761yk254u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asias He <asias@redhat.com> writes:
> scsi.c includes vhost.c which uses memcpy_fromiovec.
>
> This patch fixes this build failure.
>
>    From Randy Dunlap:
>    '''
>    on x86_64:
>
>    ERROR: "memcpy_fromiovec" [drivers/vhost/vhost_scsi.ko] undefined!
>
>    It needs to depend on NET since net/core/ provides that function.
>    '''

Proper fix please.

Though I can't see why you thought this was a good idea.  Nonetheless, I
shan't highlight why: I have far too much respect for your intellects
and abilities.

No, don't thank me!
Rusty.
