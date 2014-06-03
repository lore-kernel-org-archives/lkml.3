Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbaFCSlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:41:50 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:36043 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645AbaFCSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:41:47 -0400
Message-ID: <538E16E7.9000101@gmail.com>
Date: Tue, 03 Jun 2014 12:41:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 11/13] perf tests: Allow reuse of test_file function
References: <1401743927-398-1-git-send-email-jolsa@kernel.org> <1401743927-398-12-git-send-email-jolsa@kernel.org> <538DD2E3.2090407@gmail.com> <20140603153505.GJ2864@krava.brq.redhat.com>
In-Reply-To: <20140603153505.GJ2864@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/14, 9:35 AM, Jiri Olsa wrote:

>>> +	static char buf_templ[sizeof(TEMPL)];
>>
>> why static? and ...
>
> I need to use it outside the test_file function

Oh, it's a return variable.

David

