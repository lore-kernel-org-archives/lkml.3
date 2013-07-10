Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3GJAHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 20:07:08 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53431 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3GJAHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 20:07:07 -0400
X-AuditID: 9c93016f-b7bdeae000000e34-08-51dca5a7b2c5
Message-ID: <51DCA5A6.3060703@lge.com>
Date: Wed, 10 Jul 2013 09:07:02 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Fixup for removing -f option in perf record
References: <1372307120-737-1-git-send-email-namhyung@kernel.org> <51DBBEA8.3010208@lge.com> <51DC1C5E.3090808@gmail.com>
In-Reply-To: <51DC1C5E.3090808@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

2013-07-09 오후 11:21, David Ahern 쓴 글:
> On 7/9/13 1:41 AM, Namhyung Kim wrote:
>> Hi Arnaldo,
>>
>> You may want to merge this patch too. :)
>>
>
> He did. See 77d03596 and the note:
>
>     [ combined patch removing the -f usage in various sub-commands, such
> as 'perf sched', etc, by Namhyung Kim ]

Oops, I didn't notice this.

Thanks,
Namhyung

