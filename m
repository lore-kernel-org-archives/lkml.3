Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbaFDOAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:00:53 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49368 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaFDOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:00:52 -0400
Subject: Re: [PATCH v2 2/4] tools lib traceevent: Add options to plugins
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20140604114221.GD5555@krava.brq.redhat.com>
References: <20140603032012.088137043@goodmis.org>
	 <20140603032223.896255043@goodmis.org> <87lhtecwph.fsf@sejong.aot.lge.com>
	 <20140604114221.GD5555@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jun 2014 23:00:46 +0900
Message-ID: <1401890446.1673.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2014-06-04 (수), 13:42 +0200, Jiri Olsa:
> On Tue, Jun 03, 2014 at 03:51:22PM +0900, Namhyung Kim wrote:
> > On Mon, 02 Jun 2014 23:20:14 -0400, Steven Rostedt wrote:
> > > +void traceevent_plugin_free_options_list(char **list)
> > > +{
> > > +	int i;
> > > +
> > > +	if (!list)
> > > +		return;
> > > +
> > > +	if (list == (char **)((unsigned long)-1))
> > 
> > It also should be:
> > 
> > 	if (list == INVALID_PLUGIN_LIST_OPTION)
> > 
> > 
> > Other than that, the series looks good to me now!
> 
> can I use your Acked-by?

Sure thing!

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


