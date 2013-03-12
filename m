Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab3CLSKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:10:52 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42367 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3CLSKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:10:50 -0400
Date: Tue, 12 Mar 2013 11:10:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCHSET wq/for-3.10-tmp] workqueue: implement workqueue with
 custom worker attributes
Message-ID: <20130312181045.GB25266@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <513C61B9.5030004@cn.fujitsu.com>
 <20130310120113.GC24522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130310120113.GC24522@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sun, Mar 10, 2013 at 05:01:13AM -0700, Tejun Heo wrote:
> > >  0023-workqueue-implement-get-put_pwq.patch
> > 
> > I guess this patch and patch25 may have very deep issue VS RCU.
> 
> Hmmm... scary.  I suppose you're gonna elaborate on the review of the
> actual patch?

What happened with this?  Was it false alarm?

-- 
tejun
