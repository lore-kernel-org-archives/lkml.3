Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaIUIHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 04:07:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbaIUIH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 04:07:28 -0400
Date: Sun, 21 Sep 2014 11:10:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RFC 1/2] virtio: support for urgent descriptors
Message-ID: <20140921081048.GB2489@redhat.com>
References: <1404203661-7521-1-git-send-email-mst@redhat.com>
 <87y4w35q9w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4w35q9w.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:58:43AM +0930, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > Below should be useful for some experiments Jason is doing.
> > I thought I'd send it out for early review/feedback.
> >
> > Compiled-only at this point.
> 
> It's not a terrible idea, but it will come down to how effective it is
> in practice.
> 
> I'm tempted to make it v1.0 only though.
> 
> Cheers,
> Rusty.

Me too.
