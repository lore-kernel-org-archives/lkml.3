Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaFMMJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:09:07 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62513 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaFMMJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:09:04 -0400
Subject: Re: [PATCH 14/17] perf tools: Add report.queue-size config file
 option
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1402610913-19059-15-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
	 <1402610913-19059-15-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 21:08:58 +0900
Message-ID: <1402661338.2178.22.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-13 (금), 00:08 +0200, Jiri Olsa:
> Adding report.queue-size config file option to setup
> the maximum allocation size for session's struct
> ordered_events_queue object.

Only a config option without a command line switch?

Thanks,
Namhyung



