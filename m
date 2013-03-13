Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab3CMNzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:55:39 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:63937 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab3CMNzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:55:38 -0400
Message-ID: <51408364.8050104@gmail.com>
Date: Wed, 13 Mar 2013 07:47:16 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] perf util: Change trace info output file name
References: <1363173585-9754-1-git-send-email-namhyung@kernel.org> <1363173585-9754-7-git-send-email-namhyung@kernel.org>
In-Reply-To: <1363173585-9754-7-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/13 5:19 AM, Namhyung Kim wrote:
> -static const char *output_file = "trace.info";
> +static const char *output_file = "perf.data";
>   static int output_fd;

Not really needed. Only use is a couple of die() calls. Since the file 
name is not used on the open the die message would be misleading.

David
