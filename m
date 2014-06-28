Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaF1Cwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 22:52:31 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59955 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaF1Cwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 22:52:30 -0400
Message-ID: <53AE2DEA.2000002@gmail.com>
Date: Fri, 27 Jun 2014 20:52:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 16/18] perf tools: Add debug prints for ordered events
 queue
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org> <1403103539-16807-17-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-17-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> Adding some prints for ordered events queue, to help
> debug issues.

went to enable this and it is really odd to have to edit a config file 
to enable debugging. How about hooking it into verbose option? Maybe 
like multiple levels of -v or -v <val> or -v queue.

David
