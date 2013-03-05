Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3CETtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:49:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53541 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3CETtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:49:35 -0500
Date: Tue, 05 Mar 2013 14:49:31 -0500 (EST)
Message-Id: <20130305.144931.750128870084732663.davem@davemloft.net>
To: liuj97@gmail.com
Cc: akpm@linux-foundation.org, rientjes@google.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, maciej.rutecki@gmail.com,
        chris2553@googlemail.com, rjw@sisk.pl, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        wujianguo@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org
Subject: Re: [RFC PATCH v1 22/33] mm/SPARC: use common help functions to
 free reserved pages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362495317-32682-23-git-send-email-jiang.liu@huawei.com>
References: <1362495317-32682-1-git-send-email-jiang.liu@huawei.com>
	<1362495317-32682-23-git-send-email-jiang.liu@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 11:49:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>
Date: Tue,  5 Mar 2013 22:55:05 +0800

> Use common help functions to free reserved pages.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

Acked-by: David S. Miller <davem@davemloft.net>
