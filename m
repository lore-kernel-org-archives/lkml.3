Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3LKBPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:15:06 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62661 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3LKBPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:15:02 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-4c-52a7bc94d636
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 12/17] tracing/probes: Implement 'memory' fetch method for uprobes
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org>
	<1386570005-3368-13-git-send-email-namhyung@kernel.org>
	<52A6F455.4070807@hitachi.com>
Date: Wed, 11 Dec 2013 10:15:00 +0900
In-Reply-To: <52A6F455.4070807@hitachi.com> (Masami Hiramatsu's message of
	"Tue, 10 Dec 2013 20:00:37 +0900")
Message-ID: <87mwk8i3xn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 20:00:37 +0900, Masami Hiramatsu wrote:
> (2013/12/09 15:20), Namhyung Kim wrote:
>> @@ -493,7 +416,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
>>  			dprm->offset = offset;
>>  			dprm->fetch = t->fetch[FETCH_MTD_memory];
>>  			dprm->fetch_size = get_fetch_size_function(t,
>> -							dprm->fetch, ttbl);
>> +							dprm->fetch, ftbl);
>
> What is this change? I guess it should be included in 11/17...

Argh, right.  It looks like a git rebase artifact, will change.


> The rest of this patch is good for me.

So can I add you ack then? :)

Thank you!
Namhyung
