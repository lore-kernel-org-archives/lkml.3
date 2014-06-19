Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaFSKlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:41:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613AbaFSKls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:41:48 -0400
Date: Thu, 19 Jun 2014 12:41:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] perf tools tui: Display columns headers
Message-ID: <20140619104132.GA8416@krava.brq.redhat.com>
References: <1402851203-3083-1-git-send-email-jolsa@kernel.org>
 <87bntp8oke.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bntp8oke.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 02:18:25PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Sun, 15 Jun 2014 18:53:19 +0200, Jiri Olsa wrote:
> > hi,
> > adding the way to display columns headers in perf TUI on
> > 'H' press.
> 
> I think it'd be better if it displays the header by default.
> 
> Anyway, I see an issue..  the column headers disappeared after resize or
> a popup menu.

right, will send v2

thanks,
jirka
