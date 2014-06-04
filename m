Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaFDLm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:42:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbaFDLm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:42:27 -0400
Date: Wed, 4 Jun 2014 13:42:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] tools lib traceevent: Add options to plugins
Message-ID: <20140604114221.GD5555@krava.brq.redhat.com>
References: <20140603032012.088137043@goodmis.org>
 <20140603032223.896255043@goodmis.org>
 <87lhtecwph.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhtecwph.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:51:22PM +0900, Namhyung Kim wrote:
> On Mon, 02 Jun 2014 23:20:14 -0400, Steven Rostedt wrote:
> > +void traceevent_plugin_free_options_list(char **list)
> > +{
> > +	int i;
> > +
> > +	if (!list)
> > +		return;
> > +
> > +	if (list == (char **)((unsigned long)-1))
> 
> It also should be:
> 
> 	if (list == INVALID_PLUGIN_LIST_OPTION)
> 
> 
> Other than that, the series looks good to me now!

can I use your Acked-by?

thanks,
jirka
