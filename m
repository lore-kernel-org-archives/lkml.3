Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3DPJPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:15:11 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:61543 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3DPJPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:15:07 -0400
Date: Tue, 16 Apr 2013 11:15:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: libin <huawei.libin@huawei.com>
Cc: Jonghwan Choi <jhbird.choi@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiang.liu@huawei.com,
        guohanjun@huawei.com, Peter Zijlstra <peterz@infradead.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.8-stable] sched/debug: Fix sd->*_idx limit range
 avoiding overflow
Message-ID: <20130416091503.GD9569@gmail.com>
References: <1366035328-4780-1-git-send-email-jhbird.choi@samsung.com>
 <516CAF08.1090107@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516CAF08.1090107@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* libin <huawei.libin@huawei.com> wrote:

> On 2013/4/15 22:15, Jonghwan Choi wrote:
> > From: libin <huawei.libin@huawei.com>
> > 
> > This patch looks like it should be in the 3.8-stable tree, should we apply
> > it?
> > 
> 
> yes, I think this patch should be applied to the 3.8-stable tree. Thanks.
> Libin

Since this is a debug interface only accessible to root it's not strictly 
necessary - but I have no objection to including it in -stable.

Thanks,

	Ingo
