Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3LKB1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:27:50 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59242 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3LKB1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:27:47 -0500
Message-ID: <52A7BF8C.1030601@hitachi.com>
Date: Wed, 11 Dec 2013 10:27:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 12/17] tracing/probes: Implement 'memory' fetch method
 for uprobes
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-13-git-send-email-namhyung@kernel.org> <52A6F455.4070807@hitachi.com> <87mwk8i3xn.fsf@sejong.aot.lge.com>
In-Reply-To: <87mwk8i3xn.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/11 10:15), Namhyung Kim wrote:
> On Tue, 10 Dec 2013 20:00:37 +0900, Masami Hiramatsu wrote:
>> (2013/12/09 15:20), Namhyung Kim wrote:
>>> @@ -493,7 +416,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
>>>  			dprm->offset = offset;
>>>  			dprm->fetch = t->fetch[FETCH_MTD_memory];
>>>  			dprm->fetch_size = get_fetch_size_function(t,
>>> -							dprm->fetch, ttbl);
>>> +							dprm->fetch, ftbl);
>>
>> What is this change? I guess it should be included in 11/17...
> 
> Argh, right.  It looks like a git rebase artifact, will change.
> 
> 
>> The rest of this patch is good for me.
> 
> So can I add you ack then? :)

Yes, you can add it! :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


