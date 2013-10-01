Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3JANZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:25:06 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43907 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3JANZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:25:04 -0400
Message-ID: <524ACD2A.7040902@gmail.com>
Date: Tue, 01 Oct 2013 07:24:58 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] perf session: Fix infinite loop on invalid perf.data
 file
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org> <20131001071646.GA20023@gmail.com>
In-Reply-To: <20131001071646.GA20023@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/13 1:16 AM, Ingo Molnar wrote:
> Just a detail: it would be nice to make all the user facing messages in
> tools/perf/util/header.c more specific and more structured. For example
> prefixing it with 'perf header:' would be fine:
>
> 	WARNING: perf/header: Data size is 0. Was the 'perf record' command properly terminated?
>

Why put code references in the messages? The message is all on one line 
so grep finds it quickly for people working on the code.

David

