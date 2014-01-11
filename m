Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaAKJDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 04:03:09 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:45958 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaAKJDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 04:03:00 -0500
Message-ID: <52D108BF.8060401@colorfullife.com>
Date: Sat, 11 Jan 2014 10:02:55 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, akpm@linux-foundation.org
CC: riel@redhat.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 0/7] ipc: some misc updates & optimizations
References: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
In-Reply-To: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 01/10/2014 07:48 PM, Davidlohr Bueso wrote:
> A few updates to the ipc code, mostly some very needed cleanups (yes, we still
> have loads more to do, but it's a start). Nothing particularly interesting,
> except perhaps for the last two patches, which include a locking optimization
> and barrier documentation for message queues. Absolutely no functional changes.
>
> Applies on top of linux-next +  Manfred's 'whitespace cleanup' patch. Tested
> with LTP.
Now you confuse me.
In your other mail, you write that my patch doesn't apply to linux-next:

On 01/07/2014 06:12 PM, Davidlohr Bueso wrote:
> This patch doesn't apply on top of linux-next (which now includes 
> Rafael's changes), could you please resend? I'm planning some more 
> cleanups on top of this so, if Andrew agrees, I can include these 
> changes to my patchset. Thanks, Davidlohr 

Perhaps: Could you include (and update, if required) my patch into your 
patchset?
It's probably simpler if we have only one set of ipc cleanups around.

> Thanks!
>
> Davidlohr Bueso (7):
>    ipc: standardize code comments
>    ipc: remove braces for single statements
>    ipc: remove useless return statement
>    ipc: simplify sysvipc_proc_open return
>    ipc: delete seq_max field in struct ipc_ids
Acked-by: Manfred Spraul <manfred@colorfullife.com>
>    ipc: share ids rwsem when possible in ipcget_public
This patch is a real change. Could you at least make it the last one in 
the series?
I will try to review it, but I don't know yet when I will find the time.

>    ipc,msg: document barriers
Acked-by: Manfred Spraul <manfred@colorfullife.com>

--
     Manfred
