Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaHYI3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:29:23 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44018 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaHYI3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:29:21 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 25 Aug 2014 17:29:32 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mm/slab_common: move kmem_cache definition to
 internal header
Message-ID: <20140825082932.GC13475@js1304-P5Q-DELUXE>
References: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com>
 <53F5AD88.9050303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F5AD88.9050303@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 04:27:52PM +0800, Zhang Yanfei wrote:
> Hello Joonsoo,

Hello. :)

> 
> Seems like this is a cleanup patchset. I want to mention another
> tiny cleanup here.

I think these are not only cleanup but also build improvement.

> You removed the "struct slab" before but it seems there is still
> a slab_page field in page descriptor left and has no user now, right?

Yes, you are right. I will do it in next spin. :)

Thanks.
