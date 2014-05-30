Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbaE3RjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:39:23 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:61463 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaE3RjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:39:20 -0400
Date: Fri, 30 May 2014 13:39:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: paolo <paolo.valente@unimore.it>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC RESEND 00/14] New version of the BFQ I/O Scheduler
Message-ID: <20140530173917.GJ24871@htj.dyndns.org>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
 <20140530173146.GG16605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530173146.GG16605@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 01:31:46PM -0400, Vivek Goyal wrote:
> > What allows BFQ to provide the above features is its accurate
> > scheduling engine (patches 1-4), combined with a set of simple
> > heuristics and improvements (patches 5-14). 
> 
> This is very hard to understand. This puzzle need to be broken down
> into small pieces and explained in simple design terms so that even
> 5 years down the line I can explain why BFQ was better.

Vivek, stop wasting people's time and just go study the paper.  Let's
*please* talk after that.  What do you expect him to do?  Copy & paste
the whole paper here and walk you through each step of it?  He
presented as much information as he could and then provided sufficient
summary in the head message and as comments in the implementation.
It's now *your* turn to study what has been presented.  Sure, if you
have further questions or think that the implementation and patches
need more documentation, that's completely fine but I find it
ridiculous that you're demanding to be spoon-fed information which is
readily available in an easily consumable form.  Seriously, this is
the best documentation we've had in this area *EVER*.

-- 
tejun
