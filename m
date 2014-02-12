Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaBLDen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 22:34:43 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42663 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaBLDem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 22:34:42 -0500
Date: Tue, 11 Feb 2014 20:34:37 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        mrushton@amazon.com, msw@amazon.com, boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [GIT PULL] (xen) stable/for-jens-3.14 : NFO: trying
 to register non-static key. the code is fine but needs lockdep annotation.
Message-ID: <20140212033437.GA9739@kernel.dk>
References: <771950784.20140211165215@eikelenboom.it>
 <20140211155650.GA23026@phenom.dumpdata.com>
 <1542261541.20140211170750@eikelenboom.it>
 <52FA6072.40908@citrix.com>
 <52FA6352.1010403@citrix.com>
 <52FA68AE.6070608@citrix.com>
 <52FA6A44.6050003@citrix.com>
 <1009282985.20140211212157@eikelenboom.it>
 <52FA99CA.8070505@kernel.dk>
 <92e1a6a9-1993-4203-b38c-9c8da96a3ce7@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92e1a6a9-1993-4203-b38c-9c8da96a3ce7@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11 2014, Konrad Rzeszutek Wilk wrote:
> On February 11, 2014 4:44:42 PM EST, Jens Axboe <axboe@kernel.dk> wrote:
> >On 2014-02-11 13:21, Sander Eikelenboom wrote:
> >>
> >> Tuesday, February 11, 2014, 7:21:56 PM, you wrote:
> >>
> >>> On 11/02/14 18:15, Roger Pau Monné wrote:
> >>>> On 11/02/14 18:52, David Vrabel wrote:
> >>>>>
> >>>> That would mean that unmap_purged_grants would no longer be static
> >and
> >>>> I should also add a prototype for it in blkback/common.h, which is
> >kind
> >>>> of ugly IMHO.
> >>
> >>> But less ugly than initializing work with a NULL function, IMO.
> >>
> >>>> commit 980e72e45454b64ccb7f23b6794a769384e51038
> >>>> Author: Roger Pau Monne <roger.pau@citrix.com>
> >>>> Date:   Tue Feb 11 19:04:06 2014 +0100
> >>>>
> >>>>      xen-blkback: init persistent_purge_work work_struct
> >>>>
> >>>>      Initialize persistent_purge_work work_struct on
> >xen_blkif_alloc (and
> >>>>      remove the previous initialization done in
> >purge_persistent_gnt). This
> >>>>      prevents flush_work from complaining even if
> >purge_persistent_gnt has
> >>>>      not been used.
> >>>>
> >>>>      Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> >>
> >>> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> >>
> >> And a Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
> >
> >Konrad, I was going to ship my current tree today, but looks like we 
> >need this too.
> 
> Yes. Are you OK taking it from this thread or would you like me to prep a GIT pull with it?

I'll just grab it from here, no problem. Done.

-- 
Jens Axboe

