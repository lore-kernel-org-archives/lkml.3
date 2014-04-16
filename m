Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161808AbaDPPXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:23:34 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35210 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161788AbaDPPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140416092245.GD12866@dhcp22.suse.cz>
References: <1397149868-30401-1-git-send-email-nasa4836@gmail.com> <20140416092245.GD12866@dhcp22.suse.cz>
From: Zhan Jianyu <nasa4836@gmail.com>
Date: Wed, 16 Apr 2014 23:22:51 +0800
Message-ID: <CAHz2CGXiRnBuza6ByvuDZpuxB4sP3wDBZ2OiLTACEX7ZMAuvXw@mail.gmail.com>
Subject: Re: [PATCH] mm/memcontrol.c: make mem_cgroup_read_stat() read all
 interested stat item in one go
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>,
        kamezawa.hiroyu@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 5:22 PM, Michal Hocko <mhocko@suse.cz> wrote:
> cannot say I like the new code much more than the previous one and
> I've never seen the old one being a bottleneck. So I am not entirely
> fond of optimization without a good reason. (Hint, if you are optimizing
> something always show us numbers which support the optimization)

Hmm, actually I now have no workload to support this optimizaton, I will
refine patch if I have one.  Thanks for all your comments.

Thanks,
Jianyu Zhan
