Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaDVIIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:08:48 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44484 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaDVIIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
References: <cover.1398147734.git.nasa4836@gmail.com> <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 16:08:04 +0800
Message-ID: <CAHz2CGW62TMEVuqj8ixpPP_hOW6r4Q6VkZRtG_kKc6ibd2V=jA@mail.gmail.com>
Subject: Re: [PATCH 2/4] mm/memcontrol.c: use accessor to get id from css
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, kamezawa.hiroyu@jp.fujitsu.com
Cc: Cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Jianyu Zhan <nasa4836@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 2:30 PM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> This is a prepared patch for converting from per-cgroup id to
> per-subsystem id.
>
> We should not access per-cgroup id directly, since this is implemetation
> detail. Use the accessor css_from_id() instead.
>
> This patch has no functional change.

Hi,  I'm sorry.  This patch should be applied on top of its previous patch:
https://lkml.org/lkml/2014/4/22/54

Sorry for my fault , not cc'ing this mail-list in that patch.

Thanks,
Jianyu Zhan
