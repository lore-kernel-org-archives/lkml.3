Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaIZLZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:25:35 -0400
Received: from mx2.parallels.com ([199.115.105.18]:53251 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbaIZLZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:25:33 -0400
Date: Fri, 26 Sep 2014 15:25:24 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, Greg Thelen <gthelen@google.com>,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@sr71.net>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] mm: hugetlb_controller: convert to lockless page
 counters
Message-ID: <20140926112524.GF29445@esperanza>
References: <1411573390-9601-1-git-send-email-hannes@cmpxchg.org>
 <1411573390-9601-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411573390-9601-3-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:43:09AM -0400, Johannes Weiner wrote:
> Abandon the spinlock-protected byte counters in favor of the unlocked
> page counters in the hugetlb controller as well.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
