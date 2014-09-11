Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaIKLkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:40:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbaIKLkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:40:35 -0400
Date: Thu, 11 Sep 2014 14:43:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Rusty away 18th September -- 11th October
Message-ID: <20140911114351.GA25736@redhat.com>
References: <87oaunht4b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oaunht4b.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:26:52AM +0930, Rusty Russell wrote:
> Hi all,
> 
>         Probably won't read mail.  Linus, I'll have pull requests early
> next week; if there's anything needed I'm sure Michael Tsirkin can
> handle it.

Sure.
Rusty, there's a small chance virtio 1.0 bits will be ready in time.
I started working on them based on your virtio-pci-new-layout branch.

If ready before the merge window, are you ok with me merging this
support (without you having the opportunity to review first)?

-- 
MST
