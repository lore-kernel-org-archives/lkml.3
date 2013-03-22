Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab3CVPAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:00:07 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43632
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933410Ab3CVO7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:59:42 -0400
Date: Fri, 22 Mar 2013 08:59:27 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: akpm@linux-foundation.org, yan@linux.vnet.ibm.com, tj@kernel.org,
        ebiederm@xmission.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] loopdev: fix error return code in loop_add()
Message-ID: <20130322145927.GI25978@kernel.dk>
References: <CAPgLHd-xuqvH6tr8d+78MjX-d7E6Jb_6oyb8hV_GMw-yYyBB0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-xuqvH6tr8d+78MjX-d7E6Jb_6oyb8hV_GMw-yYyBB0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22 2013, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case, as returned elsewhere in this function.

Applied, thanks.

-- 
Jens Axboe

