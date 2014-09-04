Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaIDRpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:45:31 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:49841 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbaIDRpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:45:24 -0400
Date: Thu, 4 Sep 2014 13:45:17 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: Latchesar Ionkov <lionkov@lanl.gov>, Or Gerlitz <gerlitz.or@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
Message-ID: <20140904174517.GA2685@gmail.com>
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com>
 <5405D2D8.1040700@mellanox.com>
 <CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com>
 <CAOha14xthZHSpS_T+XRgZcPqwaZvtMw0iGTzKjTyjdBuLhJ4Eg@mail.gmail.com>
 <CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 02:15:51PM -0700, Roland Dreier wrote:
> > I would like to note that we at Los Alamos National Laboratory are very
> > interested in this functionality and it would be great if it gets accepted.
> 
> Have you done any review or testing of these changes?  If so can you
> share the results?

So jumping in here. I am working on a similar issue, ie on a subsystem that
allow a device to mirror a process address space (or part of it) using its
own mmu and page table.

While i am aiming at providing a generic API, it is not yet fully cook thus
i think having a driver implement its own code in the meantime is something
we have to live with. I am sharing the frustration of Sagi or Haggai on how
hard it is to get any kind of review.

I have not yet reviewed this code but it's nearing the top of on my todo list.
Even thought i am not an authoritative figure in either mm or rdma.

For anyone interested in taking a peak at HMM (subsystem i am working on to
provide same functionality and more) :

http://marc.info/?l=linux-mm&m=140933942705466&w=4

Cheers,
Jérôme

> 
>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
