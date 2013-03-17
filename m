Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3CQXp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 19:45:26 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:62103 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab3CQXpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 19:45:24 -0400
Message-ID: <51465591.5070003@gmail.com>
Date: Sun, 17 Mar 2013 17:45:21 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: chenggang <chenggang.qin@gmail.com>
CC: linux-kernel@vger.kernel.org, chenggang <chenggang.qcg@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 4/8]perf: Transform evsel->id to xyarray
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com> <1363167740-27735-5-git-send-email-chenggang.qin@gmail.com>
In-Reply-To: <1363167740-27735-5-git-send-email-chenggang.qin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/13 3:42 AM, chenggang wrote:

>   tools/perf/util/evlist.c |    4 +++-
>   tools/perf/util/evsel.c  |   19 +++++++++++++++++--
>   tools/perf/util/evsel.h  |    5 ++++-
>   tools/perf/util/header.c |   28 ++++++++++++++++++----------
>   tools/perf/util/header.h |    3 ++-
>   5 files changed, 44 insertions(+), 15 deletions(-)

Same comment here too -- small patches the move one reference at a time 
and then a final one that flips the implementation.

David

