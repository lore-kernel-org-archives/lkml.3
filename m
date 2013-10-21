Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3JUEDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 00:03:24 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:53663 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab3JUEDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 00:03:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIhAFKmZFJ5LAy1/2dsb2JhbABagwc4gxaKEAecbAOPHoVGgSUXdIIlAQEFOhwjEAgDFQMJJQ8FJQMhE4gFDr4OFoxvglcHgx+BCgOYCIpDh0WDOCg
Date: Mon, 21 Oct 2013 15:03:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: bpm@sgi.com, elder@kernel.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH -next] xfs: remove duplicated include from xfs_bmap.c
Message-ID: <20131021040317.GD4446@dastard>
References: <CAPgLHd-Pe_oBza-esdghKzFq5T2-Pj26YSBuEggAC9qR7vAdeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-Pe_oBza-esdghKzFq5T2-Pj26YSBuEggAC9qR7vAdeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 10:56:15AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

That's fixed in a series of patches that has already been posted for
review. See:

http://oss.sgi.com/archives/xfs/2013-10/msg00374.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
