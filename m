Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaGINpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:45:46 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50506 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbaGINpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:45:43 -0400
Message-ID: <53BD4785.5060402@gmail.com>
Date: Wed, 09 Jul 2014 07:45:41 -0600
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
Subject: Re: [PATCH 3/4] perf kvm: Add skip_event() for --duration option
References: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com> <1404397747-20939-4-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1404397747-20939-4-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/14, 8:29 AM, Alexander Yarygin wrote:
> Current code skips output of the x86 specific HLT event in order to
> avoid flooding the output with enabled --duration option. The events to
> be skipped should be architecture dependent, though.
>
> Let's add an architecture specific array of events to be skipped and
> introduce a skip_event() function checking against that array.
>
> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Reviewed-by David Ahern <dsahern@gmail.com>

Compiled and Tested on x86

