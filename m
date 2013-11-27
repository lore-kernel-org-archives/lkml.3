Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3K0PTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:19:21 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:35724 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3K0PTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:19:20 -0500
Message-ID: <52960D71.7010107@gmail.com>
Date: Wed, 27 Nov 2013 08:19:13 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] tools/perf/util: Document and clean up readn() a bit
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com> <1385130268-10664-2-git-send-email-jolsa@redhat.com> <20131125192909.GA27323@ghostprotocols.net> <20131126175335.GA9300@gmail.com> <5295AFA3.6060007@intel.com> <20131127115746.GB10528@gmail.com>
In-Reply-To: <20131127115746.GB10528@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/13, 4:57 AM, Ingo Molnar wrote:
> Okay, I thought this was an intentional 'all or nothing' interface -
> but looking at the readn() users they can tolerate partial results
> just fine.

I believe that is the intent -- an all or nothing interface.

David
