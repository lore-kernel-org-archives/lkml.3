Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbbAMP7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:59:34 -0500
Received: from mx2.parallels.com ([199.115.105.18]:53573 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbbAMP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:59:32 -0500
Date: Tue, 13 Jan 2015 18:59:24 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] mm: page_counter: pull "-1" handling out of
 page_counter_memparse()
Message-ID: <20150113155924.GB11264@esperanza>
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 11:15:03PM -0500, Johannes Weiner wrote:
> It was convenient to have the generic function handle it, as all
> callsites agreed.  Subsequent patches will add new user interfaces
> that do not want to support the "-1" special string.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
