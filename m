Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab3EOIiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:38:08 -0400
Received: from mx2.parallels.com ([199.115.105.18]:60274 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab3EOIiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:38:04 -0400
Message-ID: <5193499C.8080505@parallels.com>
Date: Wed, 15 May 2013 12:38:52 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        "Michel Lespinasse" <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch v3 -mm 2/3] memcg: Get rid of soft-limit tree infrastructure
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz> <1368431172-6844-3-git-send-email-mhocko@suse.cz>
In-Reply-To: <1368431172-6844-3-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 11:46 AM, Michal Hocko wrote:
> Now that the soft limit is integrated to the reclaim directly the whole
> soft-limit tree infrastructure is not needed anymore. Rip it out.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/memcontrol.c |  224 +------------------------------------------------------
>  1 file changed, 1 insertion(+), 223 deletions(-)
Great =)

Reviewed-by: Glauber Costa <glommer@openvz.org>
