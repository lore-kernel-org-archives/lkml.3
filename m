Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbaDXO3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:29:14 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47467 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbaDXO3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:29:10 -0400
Subject: Re: [PATCH 5/5] perf tests: Add map groups sharing with thread
 object test
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <1397490723-1992-6-git-send-email-jolsa@redhat.com>
References: <1397490723-1992-1-git-send-email-jolsa@redhat.com>
	 <1397490723-1992-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Apr 2014 23:29:04 +0900
Message-ID: <1398349744.1681.26.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-14 (월), 17:52 +0200, Jiri Olsa:
> +	/*
> +	 * Cannot call machine__delete_threads(machine) now,
> +	 * because we've already realased all the threads.

s/realased/released/

Other than that, this series looks good to me.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> +	 */
> +
> +	machines__exit(&machines);
> +	return 0;
> +}



