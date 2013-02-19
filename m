Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835Ab3BSXBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 18:01:05 -0500
Received: from ozlabs.org ([203.10.76.45]:58176 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463Ab3BSXBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:01:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, sjur.brandeland@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] vringh
In-Reply-To: <20130219081113.GA4095@redhat.com>
References: <1361226573-12481-1-git-send-email-rusty@rustcorp.com.au> <20130219081113.GA4095@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 20 Feb 2013 07:13:34 +1030
Message-ID: <878v6khw5l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Tue, Feb 19, 2013 at 08:59:27AM +1030, Rusty Russell wrote:
>> This introduces vringh, which are generic accessors for virtio rings (host side).
>> There's a host-side implementation in vhost, but it assumes that the rings are
>> in userspace, and is tied to the vhost implementation.  I have patches to adapt
>> it to use vringh, but I'm pushing this in the next merge window for Sjur, who has
>> CAIF patches which need it.
>> 
>> This also includes a test program in tools/virtio.  There's a fixup patch for
>> the current tools, since they didn't compile for me.  MST?
>> 
>> Review and comments welcome!
>> Rusty.
>
> Will review, thanks.
> Okay so the plan is to merge this changeset for 3.9 and rework vhost
> for 3.10?

I hope so, yes.

Thanks,
Rusty.
