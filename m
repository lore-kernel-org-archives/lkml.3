Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaAKRyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:54:46 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:26211 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaAKRyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:54:44 -0500
Message-ID: <1389462882.21727.36.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH -next 0/7] ipc: some misc updates & optimizations
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: akpm@linux-foundation.org, riel@redhat.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Sat, 11 Jan 2014 09:54:42 -0800
In-Reply-To: <52D108BF.8060401@colorfullife.com>
References: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
	 <52D108BF.8060401@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-11 at 10:02 +0100, Manfred Spraul wrote:
> Hi David,
> 
> On 01/10/2014 07:48 PM, Davidlohr Bueso wrote:
> > A few updates to the ipc code, mostly some very needed cleanups (yes, we still
> > have loads more to do, but it's a start). Nothing particularly interesting,
> > except perhaps for the last two patches, which include a locking optimization
> > and barrier documentation for message queues. Absolutely no functional changes.
> >
> > Applies on top of linux-next +  Manfred's 'whitespace cleanup' patch. Tested
> > with LTP.
> Now you confuse me.
> In your other mail, you write that my patch doesn't apply to linux-next:

Just ignore that email, Andrew then applied (and fixed the merge
conflict) your whitespace cleanup patch and was already in linux-next by
the time I sent this patchset, so no need to worry/coordinate.

> 
> On 01/07/2014 06:12 PM, Davidlohr Bueso wrote:
> > This patch doesn't apply on top of linux-next (which now includes 
> > Rafael's changes), could you please resend? I'm planning some more 
> > cleanups on top of this so, if Andrew agrees, I can include these 
> > changes to my patchset. Thanks, Davidlohr 
> 
> Perhaps: Could you include (and update, if required) my patch into your 
> patchset?
> It's probably simpler if we have only one set of ipc cleanups around.
> 
> > Thanks!
> >
> > Davidlohr Bueso (7):
> >    ipc: standardize code comments
> >    ipc: remove braces for single statements
> >    ipc: remove useless return statement
> >    ipc: simplify sysvipc_proc_open return
> >    ipc: delete seq_max field in struct ipc_ids
> Acked-by: Manfred Spraul <manfred@colorfullife.com>
> >    ipc: share ids rwsem when possible in ipcget_public
> This patch is a real change. Could you at least make it the last one in 
> the series?
> I will try to review it, but I don't know yet when I will find the time.

Thanks, I definitely want your ack/review for this one.

> 
> >    ipc,msg: document barriers
> Acked-by: Manfred Spraul <manfred@colorfullife.com>
> 
> --
>      Manfred


