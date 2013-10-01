Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3JAOnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:43:31 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47528 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3JAOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:43:24 -0400
Message-ID: <524ADF84.4080801@gmail.com>
Date: Tue, 01 Oct 2013 08:43:16 -0600
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
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org> <20131001071646.GA20023@gmail.com> <524ACD2A.7040902@gmail.com> <20131001142154.GA31298@gmail.com>
In-Reply-To: <20131001142154.GA31298@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/13 8:21 AM, Ingo Molnar wrote:
> But if I understood it correctly this particular message could trigger for
> regular users of perf as well, of the perf record is terminated in some
> unusual fashion. Regular users might not have the perf code handy (and
> might not know about git grep either).

This is the case I was referring to -- normal users don't care about the 
code reference, hence the more specific question about how the 
perf-record session ended.

