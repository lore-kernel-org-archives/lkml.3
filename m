Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab3FCS0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:26:15 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51630 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3FCS0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:26:12 -0400
Message-ID: <51ACDFBF.3030909@gmail.com>
Date: Mon, 03 Jun 2013 12:26:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC] perf record: Remove -A option
References: <20130603180646.GE8758@krava.brq.redhat.com>
In-Reply-To: <20130603180646.GE8758@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/13 12:06 PM, Jiri Olsa wrote:
> hi,
> the -A option (append data to the output file) for record
> command is broken, probably for some time now.
>
> Anyone interested in this functionality? As we discussed
> this with Arnaldo he and I would vote for removal.
>
> thoughts?

Acked-by: David Ahern <dsahern@gmail.com>

I ran a bisect on this problem a year ago:
http://lkml.indiana.edu/hypermail/linux/kernel/1206.3/00990.html

"Append has been broken for a long time (v2.6.36 last working version)."

David
