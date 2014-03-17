Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbaCQFlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:41:09 -0400
Received: from imap.thunk.org ([74.207.234.97]:42357 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaCQFlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:41:07 -0400
Date: Mon, 17 Mar 2014 01:40:53 -0400
From: tytso@mit.edu
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Frank Swiderski <fes@google.com>
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by
 the hypervisor
Message-ID: <20140317054053.GF14162@thunk.org>
Mail-Followup-To: tytso@mit.edu, Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Venkatesh Srinivas <venkateshs@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtio-dev@lists.oasis-open.org,
	virtualization@lists.linux-foundation.org,
	Frank Swiderski <fes@google.com>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com>
 <1394854471-25700-1-git-send-email-tytso@mit.edu>
 <87siqhu048.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siqhu048.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 11:12:15AM +1030, Rusty Russell wrote:
> 
> Note that with indirect descriptors (which is supported by Almost
> Everyone), we can actually use the full index, so this value is a bit
> pessimistic.  But it's OK as a starting point.

So is this something that can go upstream with perhaps a slight
adjustment in the commit description?  Do you think we need to be able
to dynamically adjust the queue depth after the module has been loaded
or the kernel has been booted?  If so, anyone a hint about the best
way to do that would be much appreciated.

Thanks,

					- Ted
