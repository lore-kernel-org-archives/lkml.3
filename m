Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbaF3SHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:07:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbaF3SHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:07:48 -0400
Date: Mon, 30 Jun 2014 20:07:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf tools: Add ui.show-headers config file option
Message-ID: <20140630180731.GF1236@krava.redhat.com>
References: <1403886418-5556-1-git-send-email-jolsa@kernel.org>
 <1403886418-5556-4-git-send-email-jolsa@kernel.org>
 <1404126804.1648.12.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404126804.1648.12.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 08:13:24PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> 2014-06-27 (금), 18:26 +0200, Jiri Olsa:
> > Adding report.show-headers config file option to setup
> > the appearance of the columns headers.
> > 
> > Currently columns headers are displayed by default, following
> > lines in ~/.perfconfig file will disable that:
> > 
> >   [ui]
> >         show-headers = true
> 
> s/true/false/  :)

ouch ;-)

> 
> I'm afraid that we might need to add some code to show/hide column
> headers for stdio and GTK too..
> 
> 
> > 
> > Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> Anyway, with above typo fixed, patches look good!
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

thanks,
jirka
