Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaIASNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:13:08 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38644 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbaIASNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:13:04 -0400
Message-ID: <5404B72E.1010407@gmail.com>
Date: Mon, 01 Sep 2014 12:13:02 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 0/3] perf kvm stat report: extend the title bar output
References: <1409579095-12963-1-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1409579095-12963-1-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/14, 7:44 AM, Alexander Yarygin wrote:
> Hello,
>
> This patchset is intended to add information about current pid to the
> "Analyze events for " title bar for the 'perf kvm stat report' command,
> when it's running with --pid option. To do so, patches 1-2 sync values
> of kvm->opts.target in 'report' with 'live' command and patch 3 reuses
> 'live' specific code to print desirable information.
>
> v2 changes:
>     - Split the big patch into 3 small patches
>     - Simplified the way to enable target.system_wide flag
>
> Thanks.
>
> Alexander Yarygin (3):
>    perf kvm stat report: Save pid string in kvm->opts.target.pid
>    perf kvm stat report: Enable the target.system_wide flag
>    perf kvm stat report: Unify the title bar output
>
>   tools/perf/builtin-kvm.c   |   23 ++++++++++++-----------
>   tools/perf/util/kvm-stat.h |    1 -
>   2 files changed, 12 insertions(+), 12 deletions(-)

All 3 look good to me.

Acked-by: David Ahern <dsahern@gmail.com>

