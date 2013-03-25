Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab3CYTPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 15:15:08 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39735 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab3CYTPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:15:06 -0400
Date: Mon, 25 Mar 2013 12:15:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCHSET wq/for-3.10] workqueue: NUMA affinity for unbound
 workqueues
Message-ID: <20130325191500.GA12767@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
 <20130320185708.GB31256@htj.dyndns.org>
 <CACvQF53=qgUHrr944D_70dZpT-EOMtPcz2+0JPp4kOnGPzAptQ@mail.gmail.com>
 <20130324185506.GA4378@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324185506.GA4378@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 11:55:06AM -0700, Tejun Heo wrote:
> > the whole patchset is more complicated than my brain.
> 
> It isn't that complex, is it?  I mean, the difficult part - using
> multiple pwqs on unbound wq - already happened, and even that wasn't
> too complex as it in most part synchronized the behaviors between
> per-cpu and unbound workqueues.  All that NUMA support is doing is
> mapping different pwqs to different issuing CPUs.

Oh, BTW, please feel free to rebase your patchset on top of the
current wq/for-3.10.  I'll take care of the conflicts with the numa
one, if there are any.

Thanks.

-- 
tejun
