Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3DOPbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:31:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58228 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab3DOPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:31:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <516C1CCA.80901@jp.fujitsu.com>
Date: Tue, 16 Apr 2013 00:29:14 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, mhocko@suse.cz, linux-kernel@vger.kernel.org,
        glommer@parallels.com, vgoyal@redhat.com
Subject: Re: [PATCH 4/4] memcg: force use_hierarchy if sane_behavior
References: <1365808259-31073-1-git-send-email-tj@kernel.org> <1365808259-31073-5-git-send-email-tj@kernel.org>
In-Reply-To: <1365808259-31073-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/13 8:10), Tejun Heo wrote:
> Turn on use_hierarchy by default if sane_behavior is specified and
> don't create .use_hierarchy file.
> 
> It is debatable whether to remove .use_hierarchy file or make it ro as
> the former could make transition easier in certain cases; however, the
> behavior changes which will be gated by sane_behavior are intensive
> including changing basic meaning of certain control knobs in a few
> controllers and I don't really think keeping this piece would make
> things easier in any noticeable way, so let's remove it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I'd like to say this behaivor as v2 rather than sane_behavior....

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Hmm.. we need to check performance.



