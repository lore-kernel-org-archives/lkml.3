Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234Ab3IDIS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:18:59 -0400
Received: from gmmr3.centrum.cz ([46.255.225.251]:35171 "EHLO gmmr3.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762130Ab3IDISz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:18:55 -0400
To: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Wed, 04 Sep 2013 10:18:52 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: =?utf-8?q?Andrew_Morton?= <akpm@linux-foundation.org>,
        =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>,
        =?utf-8?q?David_Rientjes?= <rientjes@google.com>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?KOSAKI_Motohiro?= <kosaki.motohiro@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <x86@kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>, <20130803170831.GB23319@cmpxchg.org>, <20130830215852.3E5D3D66@pobox.sk>, <20130902123802.5B8E8CB1@pobox.sk> <20130903204850.GA1412@cmpxchg.org>
In-Reply-To: <20130903204850.GA1412@cmpxchg.org>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130904101852.58E70042@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CC: "Andrew Morton" <akpm@linux-foundation.org>, "Michal Hocko" <mhocko@suse.cz>, "David Rientjes" <rientjes@google.com>, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
>Hello azur,
>
>On Mon, Sep 02, 2013 at 12:38:02PM +0200, azurIt wrote:
>> >>Hi azur,
>> >>
>> >>here is the x86-only rollup of the series for 3.2.
>> >>
>> >>Thanks!
>> >>Johannes
>> >>---
>> >
>> >
>> >Johannes,
>> >
>> >unfortunately, one problem arises: I have (again) cgroup which cannot be deleted :( it's a user who had very high memory usage and was reaching his limit very often. Do you need any info which i can gather now?
>
>Did the OOM killer go off in this group?
>
>Was there a warning in the syslog ("Fixing unhandled memcg OOM
>context")?



Ok, i see this message several times in my syslog logs, one of them is also for this unremovable cgroup (but maybe all of them cannot be removed, should i try?). Example of the log is here (don't know where exactly it starts and ends so here is the full kernel log):
http://watchdog.sk/lkml/oom_syslog.gz

azur
