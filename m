Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab3KFIHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:07:24 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44702 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3KFIHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:07:23 -0500
X-AuditID: 9c93017d-b7b56ae0000066c1-e2-5279f8b8d346
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf timechart improvements
References: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
	<20131105172812.GA7329@ghostprotocols.net>
Date: Wed, 06 Nov 2013 17:07:19 +0900
In-Reply-To: <20131105172812.GA7329@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 5 Nov 2013 14:28:12 -0300")
Message-ID: <87li12x8aw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 5 Nov 2013 14:28:12 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 01, 2013 at 08:25:44PM +0400, Stanislav Fomichev escreveu:
>> This patch series adds more features to the perf timechart command:
>> * -n option that adds possibility to limit number of tasks on SVG
>> * -T option that adds possibility to show only tasks related info
>> * -T and -P options now work with `perf timechart record` command to keep
>>   perf.data small
>> * -g option that adds possibility to record and add callchain to the SVG so
>>   it's now possible to understand why some task went to sleep or what code
>>   path woke it up
>> * add titles to the SVG blocks so it's possible to see how long task is
>>   running/sleeping/blocked
>> 
>> v2:
>> * fix errors pointed out by Namhyung Kim <namhyung@kernel.org>
>
> Namhyung, are you ok now? Acked-by?

Not having time to review this yet.  I think I can do it tomorrow.

Thanks,
Namhyung
