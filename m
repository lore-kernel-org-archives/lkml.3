Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaGINpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:45:49 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41933 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbaGINpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:45:47 -0400
Message-ID: <53BD4789.3070106@gmail.com>
Date: Wed, 09 Jul 2014 07:45:45 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] perf kvm: Add stat support on s390
References: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com> <1404397747-20939-5-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1404397747-20939-5-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/14, 8:29 AM, Alexander Yarygin wrote:
> On s390, the vmexit event has a tree-like structure: between
> exit_event_begin and exit_event_end several other events may happen
> and with each of them refining the previous ones.
>
> This patch adds a decoder for such events to the generic code
> and also the files <asm/kvm_perf.h> and kvm-stat.c for s390.
>
> Commands 'perf kvm stat record', 'report' and 'live' are supported.
>
> Signed-off-by: Alexander Yarygin<yarygin@linux.vnet.ibm.com>

Reviewed-by David Ahern <dsahern@gmail.com>

Compiled and Tested on x86

