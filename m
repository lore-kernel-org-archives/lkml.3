Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbaFBOaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:30:00 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33880 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbaFBO36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:29:58 -0400
Date: Mon, 2 Jun 2014 10:29:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: akpm@linux-foundation.org, mhocko@suse.cz, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, cldu@marvell.com,
        handai.szj@taobao.com, paul.gortmaker@windriver.com,
        mpatlasov@parallels.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback.c: remove outdated comment
Message-ID: <20140602142900.GN2878@cmpxchg.org>
References: <1401702440-1884-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401702440-1884-1-git-send-email-nasa4836@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 05:47:20PM +0800, Jianyu Zhan wrote:
> There is an orphaned prehistoric comment , which used to be against
> get_dirty_limits(), the dawn of global_dirtyable_memory().
> 
> Back then, the implementation of get_dirty_limits() is complicated and
> full of magic numbers, so this comment is necessary. But we now
> use the clear and neat global_dirtyable_memory(), which renders this
> comment ambiguous and useless. Remove it.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
