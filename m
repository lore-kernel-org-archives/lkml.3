Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaG2N5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:57:34 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64316 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbaG2N53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:57:29 -0400
Message-ID: <53D7A846.3060602@gmail.com>
Date: Tue, 29 Jul 2014 07:57:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Minchan Kim <minchan@kernel.org>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org> <20140729050246.GC22707@bbox> <20140729123305.GO7831@kernel.org>
In-Reply-To: <20140729123305.GO7831@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/14, 6:33 AM, Arnaldo Carvalho de Melo wrote:
>
> David, was there any reason not to do it like done in this patch?

I feel like we did at one point.
<searching>
http://www.spinics.net/lists/linux-perf-users/msg00252.html

So my original rootfs patch did use '/' after the path.

Incarnation as symfs which got accepted:
    https://lkml.org/lkml/2010/12/9/391
has it removed.

I recall you running the patch through a number of scenarios. I do not 
recall the reason '/' got dropped.

David

