Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3KAGHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 02:07:21 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45140 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3KAGHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 02:07:19 -0400
X-AuditID: 9c93016f-b7b28ae00000111e-c8-5273451512f2
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] perf timechart: use proc_num to implement --power-only
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
	<1382439412-23713-3-git-send-email-stfomichev@yandex-team.ru>
	<87txg05wrc.fsf@sejong.aot.lge.com>
	<20131029092846.GB3406@stfomichev-desktop>
Date: Fri, 01 Nov 2013 15:07:17 +0900
In-Reply-To: <20131029092846.GB3406@stfomichev-desktop> (Stanislav Fomichev's
	message of "Tue, 29 Oct 2013 13:28:46 +0400")
Message-ID: <874n7w64fe.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013 13:28:46 +0400, Stanislav Fomichev wrote:
>> I don't see how it does same thing.  You mean it by skipping
>> draw_process_bars() and draw_wakeups() on patch 1?  It'd be better
>> changelog explains the details.
> Yes, it depends on the previous patch, I'll add more info to the
> changelog.

If so, I think it'd better moving the if () parts into this patch.

Thanks,
Namhyung

>
>> And I'd like to keep it as BOOLEAN option - it's simpler and more
>> straight-forward IMHO.
>> 
>> How about adding
>> 
>> 	if (power_only)
>> 		proc_num = 0;
>> 
>> after parsing the command line options?
> Ok, this works too.
