Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbbAIPZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:25:32 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63614 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbbAIPZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:25:25 -0500
Message-ID: <54AFF2E2.6040505@gmail.com>
Date: Fri, 09 Jan 2015 08:25:22 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf probe can't insert return kprobe
References: <20150109145539.GC14750@krava.brq.redhat.com> <20150109152113.GA29697@danjae>
In-Reply-To: <20150109152113.GA29697@danjae>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/15 8:21 AM, Namhyung Kim wrote:
> Is it just return probe?  Did it work for normal kprobes?
> Maybe it's related to the below:
>
> https://lkml.org/lkml/2014/12/31/15
>
> Have you check the acme/perf/urgent too?

I believe that commit impacts uprobes only.

David

