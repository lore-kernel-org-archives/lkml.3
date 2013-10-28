Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab3J1SU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:20:58 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34503 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab3J1SU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:20:57 -0400
Message-ID: <526EAB05.6090800@gmail.com>
Date: Mon, 28 Oct 2013 12:20:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/4] perf tools: Split -g and --call-graph for record
 command
References: <20131026120336.GA24439@gmail.com> <1382797536-32303-1-git-send-email-jolsa@redhat.com> <1382797536-32303-2-git-send-email-jolsa@redhat.com> <526D317E.80408@gmail.com> <20131028174613.GA3811@infradead.org>
In-Reply-To: <20131028174613.GA3811@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 11:46 AM, Arnaldo Carvalho de Melo wrote:
> Added this:
>
> --call-graph::
>          Setup and enable call-graph (stack chain/backtrace) recording,
>          implies -g.
>
>          Allows specifying "fp" (frame pointer) or "dwarf"
>          (DWARF's CFI - Call Frame Information) as the method to collect
>          the information used to show the call graphs.
>
>          In some systems, where binaries are build wit gcc

s/wit/with/

David
