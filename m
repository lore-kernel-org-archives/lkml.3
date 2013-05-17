Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3EQBiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 21:38:10 -0400
Received: from ozlabs.org ([203.10.76.45]:59121 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab3EQBiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 21:38:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: fix uapi header
In-Reply-To: <20130516164410.GA31985@redhat.com>
References: <20130516164410.GA31985@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 17 May 2013 10:46:51 +0930
Message-ID: <87sj1m8kxo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> uapi should use __u32 not u32.
> Fix a macro in virtio_console.h which uses u32.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Ouch.  Added CC:stable, and put into fixes.  Mainly because it's
embarrassing :)

Cheers,
Rusty.
