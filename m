Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbbAEPbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:31:06 -0500
Received: from mx2.parallels.com ([199.115.105.18]:56278 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbAEPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:31:04 -0500
Date: Mon, 5 Jan 2015 18:30:54 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: memcontrol: track move_lock state internally
Message-ID: <20150105153054.GA31111@esperanza>
References: <1420232327-13316-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420232327-13316-1-git-send-email-hannes@cmpxchg.org>
X-Originating-IP: [81.5.99.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 03:58:47PM -0500, Johannes Weiner wrote:
> The complexity of memcg page stat synchronization is currently leaking
> into the callsites, forcing them to keep track of the move_lock state
> and the IRQ flags.  Simplify the API by tracking it in the memcg.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
