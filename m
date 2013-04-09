Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935334Ab3DISfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:35:15 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:33879 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761628Ab3DISfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:35:13 -0400
Date: Tue, 9 Apr 2013 11:35:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] workqueue: use kmem_cache_free() instead of kfree()
Message-ID: <20130409183508.GE6186@mtj.dyndns.org>
References: <CAPgLHd_MMO5pCMzQnfomBKkK+waYqQzpzDpX9AAP4FV7Cp0xEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_MMO5pCMzQnfomBKkK+waYqQzpzDpX9AAP4FV7Cp0xEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:29:11PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> memory allocated by kmem_cache_alloc() should be freed using
> kmem_cache_free(), not kfree().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Oops, thanks for fixing it.  Applied to wq/for-3.10.

Thanks!

-- 
tejun
