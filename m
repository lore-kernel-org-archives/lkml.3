Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3HZUSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:18:51 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:42701 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3HZUSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:18:49 -0400
Date: Tue, 27 Aug 2013 00:18:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dave Jones <davej@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: unused swap offset / bad page map.
Message-ID: <20130826201846.GA23724@moon>
References: <CAJd=RBCyZU8PR7mbFUdKsWq3OH+5HccEWKMEH5u7GNHNy3esWg@mail.gmail.com>
 <20130819231836.GD14369@redhat.com>
 <CAJd=RBA-UZmSTxNX63Vni+UPZBHwP4tvzE_qp1ZaHBqcNG7Fcw@mail.gmail.com>
 <20130821204901.GA19802@redhat.com>
 <CAJd=RBBNCf5_V-nHjK0gOqS4OLMszgB7Rg_WMf4DvL-De+ZdHA@mail.gmail.com>
 <20130823032127.GA5098@redhat.com>
 <CAJd=RBArkh3sKVoOJUZBLngXtJubjx4-a3G6s7Tn0N=Pr1gU4g@mail.gmail.com>
 <20130823035344.GB5098@redhat.com>
 <CAJd=RBBtY-nJfo9nzG5gtgcvB2bz+sxpK5kX33o1sLeLhvEU1Q@mail.gmail.com>
 <20130826190757.GB27768@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826190757.GB27768@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 03:08:22PM -0400, Dave Jones wrote:
> On Mon, Aug 26, 2013 at 11:45:53AM +0800, Hillf Danton wrote:
>  > On Fri, Aug 23, 2013 at 11:53 AM, Dave Jones <davej@redhat.com> wrote:
>  > >
>  > > It actually seems worse, seems I can trigger it even easier now, as if
>  > > there's a leak.
>  > >
>  > Can you please try the new fix for TLB flush?
>  > 
>  > commit  2b047252d087be7f2ba
>  > Fix TLB gather virtual address range invalidation corner cases
> 
> No luck.

Hi Dave, could you please put your .config somewhere so i would try
to repeat this problem? (i've tried trinity with -C64 but it didn't
trigger the issue).
