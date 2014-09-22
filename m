Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaIVIZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:25:54 -0400
Received: from mx2.parallels.com ([199.115.105.18]:59597 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaIVIZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:25:53 -0400
Date: Mon, 22 Sep 2014 12:25:46 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] mm: memcontrol: remove obsolete kmemcg pinning tricks
Message-ID: <20140922082546.GB18526@esperanza>
References: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
 <1411243235-24680-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411243235-24680-3-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 04:00:34PM -0400, Johannes Weiner wrote:
> As charges now pin the css explicitely, there is no more need for
> kmemcg to acquire a proxy reference for outstanding pages during
> offlining, or maintain state to identify such "dead" groups.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
