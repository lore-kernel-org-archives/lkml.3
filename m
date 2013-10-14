Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3JNS6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:58:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37494 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3JNS6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:58:38 -0400
Message-ID: <525C3EC2.20404@infradead.org>
Date: Mon, 14 Oct 2013 11:58:10 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>, Kent Overstreet <kmo@daterainc.com>,
        linux-bcache@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 14 (bcache)
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/13 07:48, Thierry Reding wrote:
> Hi all,
> 
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
> 
>         git://gitorious.org/thierryreding/linux-next.git
> 
> A next-20131014 tag is also provided for convenience.
> 
> Gained a few conflicts, but nothing too exciting. x86 and ARM default
> configurations build fine. There were some build failures unrelated to

Maybe you could build allmodconfig instead of a default config
for more better coverage?  I am seeing lots of build problems.

> the merge, most of which I fixed and added as patches on top of the
> final merge.


on x86_64:

drivers/md/bcache/request.c: In function 'cached_dev_write':
drivers/md/bcache/request.c:1076:8: error: 'struct btree_op' has no member named 'cache_bio'


-- 
~Randy
