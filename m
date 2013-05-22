Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3EVTs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:48:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43310 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab3EVTs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:48:56 -0400
Date: Thu, 23 May 2013 04:48:50 +0900
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-crypt@saout.de,
        Christian Schmidt <schmidt@digadd.de>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
        Andi Kleen <andi@firstfloor.org>,
        Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Message-ID: <20130522194850.GB23845@mtj.dyndns.org>
References: <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org>
 <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
 <20130412182941.GF11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304150827480.1859@file.rdu.redhat.com>
 <20130416172418.GB2874@mtj.dyndns.org>
 <20130418164742.GA8254@redhat.com>
 <20130418170317.GA9897@mtj.dyndns.org>
 <20130522185014.GA17423@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522185014.GA17423@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, May 22, 2013 at 02:50:14PM -0400, Mike Snitzer wrote:
> Was wondering: how is percpu-refcounting coming along?  Do you have a
> pointer to the code that can be pulled in for use by Mikulas' dm-crypt
> changes?
> 
> Would be nice to get this stuff sorted out for the 3.11 merge window.

Still in progress.  Waiting for Kent's next round and yeah I do hope
so too as I really wanna convert css refcnting to it regardless of
dm-crypt work.  The thread is at

 https://patchwork.kernel.org/patch/2562111/

Thanks.

-- 
tejun
