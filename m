Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3BLVcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:32:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3BLVcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:32:09 -0500
Date: Tue, 12 Feb 2013 13:32:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alex Bligh <alex@alex.org.uk>, linux-kernel@vger.kernel.org,
        nbd-general@lists.sf.net, Paul Clements <Paul.Clements@steeleye.com>
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
Message-Id: <20130212133207.ef6b24f5.akpm@linux-foundation.org>
In-Reply-To: <511A8491.5030407@redhat.com>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
	<1360685171-3792-2-git-send-email-pbonzini@redhat.com>
	<115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk>
	<511A8491.5030407@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 19:06:09 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 12/02/2013 18:37, Alex Bligh ha scritto:
> > For my education, why remove the FUA stuff?
> 
> Because I had no way to test it.
> 
> >>> > > Hmmm... the underlying storage could be md/dm RAIDs in which case FUA
> >>> > > should be cheaper than FLUSH.
> >> > 
> >> > If someone ever wrote a virtio-blk backend that sits directly ontop
> >> > of the Linux block layer that would be true.
> > In this case we don't know what the backend is sitting on top of
> > a-priori. It might be the current nbd server code, but it might
> > not be.
> 
> Do you know of any other NBD server than the "official" one and qemu-nbd?
> 

Obviously the changelog was inadequate.  Please send along a new one
which fully describes the reasons for this change.

