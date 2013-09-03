Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab3ICRjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225Ab3ICRjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:39:37 -0400
Date: Tue, 3 Sep 2013 20:39:31 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2] tile: support KVM for tilegx
Message-ID: <20130903173931.GO10142@redhat.com>
References: <52091682.8020004@siemens.com>
 <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com>
 <20130825113953.GN8218@redhat.com>
 <521AAED7.4080407@tilera.com>
 <20130826120445.GD8218@redhat.com>
 <52261D26.7060206@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52261D26.7060206@tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 01:32:22PM -0400, Chris Metcalf wrote:
> On 8/26/2013 8:04 AM, Gleb Natapov wrote:
> > On Sun, Aug 25, 2013 at 09:26:47PM -0400, Chris Metcalf wrote:
> >> On 8/25/2013 7:39 AM, Gleb Natapov wrote:
> >>> On Mon, Aug 12, 2013 at 04:24:11PM -0400, Chris Metcalf wrote:
> >>>> This change provides the initial framework support for KVM on tilegx.
> >>>> Basic virtual disk and networking is supported.
> >>>>
> >>> This needs to be broken down to more reviewable patches.
> 
> Ping!  I'd like to ask Linus to pull the tile tree now that 3.12 is open.
> Let me know if this would be problematic for you.  
> 
That was sent to close to merge window and I and Paolo had vocations in
August so with the email backlog we had no time to review it. Lets wait
for 2.13 and I will give its review top priority after the merge
windows.

> I think the tile KVM bits are in good enough shape that it makes sense
> to pull them, and if there are follow-up concerns they can be addressed
> later in the 3.12-rc series, or in future kernel releases.
> 
> In particular, it's probably worth noting the one generic change in the
> series, which is adding a KVM_EXIT_AGAIN value.  If this seems like it
> might be problematic, I can pull it for now and leave it for later review;
> it's basically just a performance optimization.
> 
> The v3 series is at:
> 
> https://lkml.org/lkml/2013/8/28/675
> https://lkml.org/lkml/2013/8/28/672
> https://lkml.org/lkml/2013/8/28/676
> 
> Thank you!
> 
> -- 
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com

--
			Gleb.
