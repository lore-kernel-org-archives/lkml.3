Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaKSBUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:20:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbaKSBUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:20:23 -0500
Date: Tue, 18 Nov 2014 17:20:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Amos Kong <akong@redhat.com>
Cc: stable@vger.kernel.org, rusty@rustcorp.com.au, amit.shah@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16 stable PATCH 0/2] virtio-rng: two backports to fix stuck
Message-ID: <20141119012022.GB22731@kroah.com>
References: <1412981509-30025-1-git-send-email-akong@redhat.com>
 <20141104043227.GA13409@air.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104043227.GA13409@air.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 12:32:27PM +0800, Amos Kong wrote:
> On Sat, Oct 11, 2014 at 06:51:47AM +0800, Amos Kong wrote:
> > I received two mails about faile to apply patches to 3.16-stable tree:
> > 
> > FAILED: patch "[PATCH] virtio-rng: skip reading when we start to remove the device" failed to apply to 3.16-stable tree
> > FAILED: patch "[PATCH] virtio-rng: fix stuck of hot-unplugging busy device" failed to apply to 3.16-stable tree
> > 
> > Amit already backported two patches for 3.16-stable, then cherry-pick
> > of my two patches works.
> > 
> > Thanks.
> 
> Ping Greg, thanks.

Why me?  3.16-stable is end-of-life, I'm no longer maintaining it, so
what can I do here with these patches?

confused,

greg k-h
