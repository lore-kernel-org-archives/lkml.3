Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3J2Jdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:33:35 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:37703 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084Ab3J2Jdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:33:32 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 29 Oct 2013 13:33:29 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] perf timechart: add support for displaying only
 tasks related data
Message-ID: <20131029093329.GC3406@stfomichev-desktop>
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
 <1382439412-23713-4-git-send-email-stfomichev@yandex-team.ru>
 <87ppqo5wgx.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppqo5wgx.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm.. double negation is always confusing to me. :-/  How about making
> it a boolean option that sets "task_only" variable?
Ok.

> Also need to update the doc.  And what if user gives -P and -T options
> at the same time?
Is something like this is enough (or you'd like some printout with error
details)?

if (!proc_num && task_only)
		usage_with_options(timechart_usage, options);
