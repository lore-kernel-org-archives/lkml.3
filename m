Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbaJWDG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 23:06:59 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59579 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763AbaJWDG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 23:06:58 -0400
Message-ID: <544870C1.205@linux.vnet.ibm.com>
Date: Thu, 23 Oct 2014 08:36:41 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCHSET 0/5] perf tools: option parsing improvement
References: <1413990949-13953-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1413990949-13953-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102303-0009-0000-0000-0000007F84ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,
On 10/22/2014 08:45 PM, Namhyung Kim wrote:
> Hello,
>
> This patchset tries to enhance option parser a bit.  Patch 1-3 are to
> reuse existing perf record options for other commands like perf kvm
> stat record.  Patch 4-5 are to support exclusive options that cannot
> be used at the same time.  The perf probe has such options and upcoming
> sdt-cache command also.

Thank you for working on this.

[SNIP]

-- 
Thanks,
Hemant Kumar

