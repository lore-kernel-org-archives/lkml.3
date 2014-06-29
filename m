Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaF2QrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:47:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbaF2QrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:47:09 -0400
Date: Sun, 29 Jun 2014 18:46:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 16/18] perf tools: Add debug prints for ordered events
 queue
Message-ID: <20140629164652.GD1407@krava.redhat.com>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
 <1403103539-16807-17-git-send-email-jolsa@kernel.org>
 <53AE2DEA.2000002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AE2DEA.2000002@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 08:52:26PM -0600, David Ahern wrote:
> On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> >Adding some prints for ordered events queue, to help
> >debug issues.
> 
> went to enable this and it is really odd to have to edit a config file to
> enable debugging. How about hooking it into verbose option? Maybe like
> multiple levels of -v or -v <val> or -v queue.

seems like verbose option factoring.. in future ;-) I can live
without this patch though.. it was mainly for testing my changes

thanks,
jirka
