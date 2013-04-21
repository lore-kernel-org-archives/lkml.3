Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab3DUB3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 21:29:31 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57761 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3DUB3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 21:29:30 -0400
Date: Sat, 20 Apr 2013 18:29:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
Message-ID: <20130421012925.GA19097@mtj.dyndns.org>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
 <20130404141229.GD9425@htj.dyndns.org>
 <CACvQF53uo0KCY20PyO8LKhs9g0Mt-OSJdv4F0P-cODWyL-TxQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF53uo0KCY20PyO8LKhs9g0Mt-OSJdv4F0P-cODWyL-TxQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 12:12:14AM +0800, Lai Jiangshan wrote:
> > I want an assertion here.
> 
> freezing codes is very simple for verifying.

I still want it (and your patch is removing it).  The usual cases are
fine but things can get messy on edge cases like freeze failure, bugs
in freezer code itself or whatnot.  Please keep the assertion.

Thanks.

-- 
tejun
