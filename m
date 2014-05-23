Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaEWRkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:40:04 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:50238 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaEWRkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:40:01 -0400
Date: Fri, 23 May 2014 13:39:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Message-ID: <20140523173957.GA31780@htj.dyndns.org>
References: <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
 <20140423171720.GF24651@redhat.com>
 <20140423185231.GA4163@mtj.dyndns.org>
 <20140423185835.GD22755@redhat.com>
 <20140423190043.GB4163@mtj.dyndns.org>
 <20140423192108.GF22755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423192108.GF22755@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Wed, Apr 23, 2014 at 03:21:09PM -0400, Vivek Goyal wrote:
> What about sync/async differentiation? Throttling layer seems to flag a request sync
> only if bio->bi_rw flag has REQ_SYNC set. While CFQ seems to consider
> request sync if bio is either read or bio->bi_rw has REQ_SYNC flag set.

Working on this again, AFAICS, both treat REQ_SYNC the same way as far
as stats are concerned.  If SYNC is set, it's sync; otherwise, it's
accounted as async whether read or write.

Thanks.

-- 
tejun
