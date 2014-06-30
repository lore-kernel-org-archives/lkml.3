Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaF3LNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:13:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62456 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaF3LNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:13:32 -0400
Subject: Re: [PATCH 3/3] perf tools: Add ui.show-headers config file option
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1403886418-5556-4-git-send-email-jolsa@kernel.org>
References: <1403886418-5556-1-git-send-email-jolsa@kernel.org>
	 <1403886418-5556-4-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jun 2014 20:13:24 +0900
Message-ID: <1404126804.1648.12.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2014-06-27 (금), 18:26 +0200, Jiri Olsa:
> Adding report.show-headers config file option to setup
> the appearance of the columns headers.
> 
> Currently columns headers are displayed by default, following
> lines in ~/.perfconfig file will disable that:
> 
>   [ui]
>         show-headers = true

s/true/false/  :)

I'm afraid that we might need to add some code to show/hide column
headers for stdio and GTK too..


> 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Anyway, with above typo fixed, patches look good!

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


