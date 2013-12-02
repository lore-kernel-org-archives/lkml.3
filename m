Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3LBUWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:22:19 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47453 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3LBUWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:22:14 -0500
Message-ID: <529CEBF1.4050004@gmail.com>
Date: Mon, 02 Dec 2013 13:22:09 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] perf report: Add --show-time-info option
References: <20131202192315.GA17149@ghostprotocols.net> <529CDEA6.8000807@gmail.com> <20131202193850.GC17149@ghostprotocols.net> <529CE66B.5070209@gmail.com> <20131202201705.GE17149@ghostprotocols.net>
In-Reply-To: <20131202201705.GE17149@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, 1:17 PM, Arnaldo Carvalho de Melo wrote:
> Probably, yeah, Ingo made some point about using --show- for some reason,
> Ingo?
>
> One I can think of is that, in general, plain --feature can mean, at
> least, one of --enable-feature and --show-feature, so perhaps that is
> the point.
>
> But then, perhaps that may be implied by the context, i.e.  when
> recording, --feature means enable it, while when reporting, what we're
> doing is basically_showing_  things, so --feature means just that.

exactly. perf has just --call-graph for both record and report, not 
enable-call-graph and show-call-graph.

David
