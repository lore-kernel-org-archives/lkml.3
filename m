Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3IENAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:00:50 -0400
Received: from gmmr1.centrum.cz ([46.255.225.252]:45419 "EHLO gmmr1.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab3IENAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:00:47 -0400
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Thu, 05 Sep 2013 15:00:44 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>,
        =?utf-8?q?Andrew_Morton?= <akpm@linux-foundation.org>,
        =?utf-8?q?David_Rientjes?= <rientjes@google.com>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?KOSAKI_Motohiro?= <kosaki.motohiro@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <x86@kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20130904115741.GA28285@dhcp22.suse.cz>, <20130904141000.0F910EFA@pobox.sk>, <20130904122632.GB28285@dhcp22.suse.cz>, <20130905111430.CB1392B4@pobox.sk>, <20130905095331.GA9702@dhcp22.suse.cz>, <20130905121700.546B5881@pobox.sk>, <20130905111742.GC9702@dhcp22.suse.cz>, <20130905134702.C703F65B@pobox.sk>, <20130905120347.GA13666@dhcp22.suse.cz>, <20130905143343.AF56A889@pobox.sk> <20130905124523.GC13666@dhcp22.suse.cz>
In-Reply-To: <20130905124523.GC13666@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130905150044.ED46FBDF@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Thu 05-09-13 14:33:43, azurIt wrote:
>[...]
>> >Just to be sure I got you right. You have killed all the processes from
>> >the group you have sent stacks for, right? If that is the case I am
>> >really curious about processes sitting in sleep_on_page_killable because
>> >those are killable by definition.
>> 
>> Yes, my script killed all of that processes right after taking
>> stack.
>
>OK, _after_ part is important. Has the group gone away after then?



If you mean if it wasn't making problems after killing it's processes, then yes.
