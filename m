Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab3C1Po3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:44:29 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47305
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887Ab3C1Po0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:44:26 -0400
Date: Thu, 28 Mar 2013 09:44:11 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mg_disk: fix error return code in mg_probe()
Message-ID: <20130328154411.GB19488@kernel.dk>
References: <CAPgLHd87a0=e8pX4YRwpxzxk1=YgcVimjxTFnpJKH8wRs1WfjQ@mail.gmail.com>
 <000501ce2b6e$db4963e0$91dc2ba0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501ce2b6e$db4963e0$91dc2ba0$%han@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28 2013, Jingoo Han wrote:
> On Thursday, March 28, 2013 1:32 PM, Wei Yongjun wrote:
> > 
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Fix to return a negative error code from the error handling
> > case instead of 0, as returned elsewhere in this function.
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> CC'ed Jens Axboe
> 
> It looks good.
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Applied, thanks guys.

-- 
Jens Axboe

