Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3BDHgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:36:09 -0500
Received: from mx2.parallels.com ([64.131.90.16]:41958 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab3BDHgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:36:06 -0500
Message-ID: <510F64F9.2050706@parallels.com>
Date: Mon, 4 Feb 2013 11:36:25 +0400
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: stop warning on memcg_propagate_kmem
References: <alpine.LNX.2.00.1302032023280.4611@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1302032023280.4611@eggly.anvils>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 08:29 AM, Hugh Dickins wrote:
> Whilst I run the risk of a flogging for disloyalty to the Lord of Sealand,
> I do have CONFIG_MEMCG=y CONFIG_MEMCG_KMEM not set, and grow tired of the
> "mm/memcontrol.c:4972:12: warning: `memcg_propagate_kmem' defined but not
> used [-Wunused-function]" seen in 3.8-rc: move the #ifdef outwards.
> 

Thanks my dear Hugh,

This is no disloyalty at all, and your braveness is indeed much appreciated.

My bad for letting that one slip

