Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3KFW7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:59:04 -0500
Received: from relay3.sgi.com ([192.48.152.1]:45991 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232Ab3KFW7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:59:02 -0500
Date: Wed, 6 Nov 2013 16:59:00 -0600
From: Ben Myers <bpm@sgi.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: elder@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH V2] xfs: simplify kmem_{zone_}zalloc
Message-ID: <20131106225900.GW1935@sgi.com>
References: <52777511.1020605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52777511.1020605@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 06:21:05PM +0800, Gu Zheng wrote:
> Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
> kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
> in order to avoid the setting to zero step. 
> And following Dave's suggestion, make kmem_{zone_}zalloc static inline
> into kmem.h as they're now just a simple wrapper.
> 
> V2:
>   Make kmem_{zone_}zalloc static inline into kmem.h as Dave suggested.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Applied.  Thanks!
