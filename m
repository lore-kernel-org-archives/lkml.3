Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbbANOGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:06:13 -0500
Received: from mx2.parallels.com ([199.115.105.18]:47434 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbbANOGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:06:11 -0500
Date: Wed, 14 Jan 2015 17:06:03 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: memcontrol: fold move_anon() and move_file()
Message-ID: <20150114140603.GD11264@esperanza>
References: <1421175592-14179-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1421175592-14179-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 01:59:52PM -0500, Johannes Weiner wrote:
> Turn the move type enum into flags and give the flags field a shorter
> name.  Once that is done, move_anon() and move_file() are simple
> enough to just fold them into the callsites.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
