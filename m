Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3BFBRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:17:32 -0500
Received: from gmmr4.centrum.cz ([46.255.227.253]:43281 "EHLO gmmr4.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab3BFBRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:17:30 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Wed, 06 Feb 2013 02:17:21 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121218152223.6912832C@pobox.sk>, <20121218152004.GA25208@dhcp22.suse.cz>, <20121224142526.020165D3@pobox.sk>, <20121228162209.GA1455@dhcp22.suse.cz>, <20121230020947.AA002F34@pobox.sk>, <20121230110815.GA12940@dhcp22.suse.cz>, <20130125160723.FAE73567@pobox.sk>, <20130125163130.GF4721@dhcp22.suse.cz>, <20130205134937.GA22804@dhcp22.suse.cz>, <20130205154947.CD6411E2@pobox.sk> <20130205160934.GB22804@dhcp22.suse.cz>
In-Reply-To: <20130205160934.GB22804@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130206021721.1AE9E3C7@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>5-memcg-fix-1.patch is not complete. It doesn't contain the folloup I
>mentioned in a follow up email. Here is the full patch:


Here is the log where OOM, again, killed MySQL server [search for "(mysqld)"]:
http://www.watchdog.sk/lkml/oom_mysqld6

azur
