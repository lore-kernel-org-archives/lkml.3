Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3J0PMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 11:12:08 -0400
Received: from fifo99.com ([67.223.236.141]:38340 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab3J0PMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 11:12:06 -0400
Date: Sun, 27 Oct 2013 08:12:00 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cgroups: remove calls to simple_kstrtoll
Message-ID: <20131027151200.GB4801@fifo99.com>
References: <1382754793-8827-3-git-send-email-dwalker@fifo99.com>
 <20131027113925.GF14934@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027113925.GF14934@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sure , I can add it .. It's because simple_strtoll is obsolete ..

On Sun, Oct 27, 2013 at 07:39:25AM -0400, Tejun Heo wrote:
> On Fri, Oct 25, 2013 at 07:33:13PM -0700, Daniel Walker wrote:
> > Signed-off-by: Daniel Walker <dwalker@fifo99.com>
> 
> Can you please briefly explain why this conversion is happening in the
> patch description?
> 
> Thanks.
> 
> -- 
> tejun
> 
