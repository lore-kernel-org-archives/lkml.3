Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaCONVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 09:21:09 -0400
Received: from imap.thunk.org ([74.207.234.97]:41751 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbaCONVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 09:21:07 -0400
Date: Sat, 15 Mar 2014 09:20:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Frank Swiderski <fes@google.com>
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by
 the hypervisor
Message-ID: <20140315132045.GA14196@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Venkatesh Srinivas <venkateshs@google.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtio-dev@lists.oasis-open.org,
	virtualization@lists.linux-foundation.org,
	Frank Swiderski <fes@google.com>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com>
 <1394854471-25700-1-git-send-email-tytso@mit.edu>
 <990f1cbc-fa54-4cb2-a9ee-394a1a6d5f07@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <990f1cbc-fa54-4cb2-a9ee-394a1a6d5f07@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 06:57:01AM -0400, Konrad Rzeszutek Wilk wrote:
> >+	pr_info("%s: using queue depth %d\n", vblk->disk->disk_name,
> >+		virtio_mq_reg.queue_depth);
> 
> Isn't that visible from sysfs?

As near as I can tell, it's not.  I haven't been able to find anything
that either represents this value, or can be calculated from this
value.  Maybe I missed something?

						- Ted
