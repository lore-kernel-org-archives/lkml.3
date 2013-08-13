Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3HMWoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:44:34 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55613 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab3HMWoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:44:32 -0400
Date: Tue, 13 Aug 2013 18:44:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] idr: Document ida tree sections
Message-ID: <20130813224428.GG28996@mtj.dyndns.org>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-4-git-send-email-kmo@daterainc.com>
 <20130807202201.GA28039@mtj.dyndns.org>
 <20130807205117.GC11612@kmo-pixel>
 <20130809145756.GL20515@mtj.dyndns.org>
 <20130813221308.GA11980@kmo-pixel>
 <20130813221928.GE28996@mtj.dyndns.org>
 <20130813222759.GA12069@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813222759.GA12069@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Tue, Aug 13, 2013 at 03:27:59PM -0700, Kent Overstreet wrote:
> It's only naturally a radix tree problem _if_ you require sparseness.

Well, it's not necessarily about requiring it but more about surviving
it with some grace when things don't go as expected, which is an
important characteristic for common library stuff.

> Otherwise, radix trees require pointer chasing, which we can avoid -
> which saves us both the cost of chasing pointers (which is significant)
> and the overhead of storing them.

Vast majority of which can be avoided with simple caching, right?

Thanks.

-- 
tejun
