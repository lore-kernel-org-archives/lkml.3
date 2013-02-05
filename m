Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3BEQP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:15:26 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38845 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3BEQPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:15:24 -0500
Message-ID: <51113018.80503@gmail.com>
Date: Tue, 05 Feb 2013 09:15:20 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/2] perf scripts: Fix rwtop record script
References: <1360080351-3246-1-git-send-email-jolsa@redhat.com> <1360080351-3246-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1360080351-3246-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/13 9:05 AM, Jiri Olsa wrote:
> Adding -D option into the rwtop record command line, to get
> immediate response when there's event in the buffer.

Seems like this will dramatically increase CPU usage of perf-record as 
well as increase the overhead of each event with a process wakeup. How 
about a poll option on perf-record to have it wake up at a given rate 
instead?

David
