Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3J2J2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:28:51 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:37558 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168Ab3J2J2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:28:50 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 29 Oct 2013 13:28:46 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] perf timechart: use proc_num to implement
 --power-only
Message-ID: <20131029092846.GB3406@stfomichev-desktop>
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
 <1382439412-23713-3-git-send-email-stfomichev@yandex-team.ru>
 <87txg05wrc.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txg05wrc.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't see how it does same thing.  You mean it by skipping
> draw_process_bars() and draw_wakeups() on patch 1?  It'd be better
> changelog explains the details.
Yes, it depends on the previous patch, I'll add more info to the
changelog.

> And I'd like to keep it as BOOLEAN option - it's simpler and more
> straight-forward IMHO.
> 
> How about adding
> 
> 	if (power_only)
> 		proc_num = 0;
> 
> after parsing the command line options?
Ok, this works too.
