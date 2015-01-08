Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbbAHOqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:46:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbbAHOqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:46:22 -0500
Date: Thu, 8 Jan 2015 15:45:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/30] perf tools: Add new build framework support
Message-ID: <20150108144514.GE16094@krava.brq.redhat.com>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
 <1420212972-21595-2-git-send-email-jolsa@kernel.org>
 <20150108061835.GD7268@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108061835.GD7268@sejong>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:18:35PM +0900, Namhyung Kim wrote:
> On Fri, Jan 02, 2015 at 04:35:43PM +0100, Jiri Olsa wrote:
> > Adding new build framework. There's no change for actual
> > building at this point, it comes in the next patches.
> > 
> > The idea and more details are explained in the
> > 'Documentation/Build' file.
> 
> 
> [SNIP]
> > diff --git a/tools/perf/Documentation/Build b/tools/perf/Documentation/Build
> > new file mode 100644
> > index 000000000000..7008520600eb
> > --- /dev/null
> > +++ b/tools/perf/Documentation/Build
> > @@ -0,0 +1,123 @@
> > +
> > +1) perf build
> > +=============
> > +The perf build process consists of several separated building blocks,
> > +which are linked together to form the perf binary:
> > +  - libperf library (static)
> > +  - perf builtin commands
> > +  - traceevent library (static)
> > +  - GTK ui library
> 
> And libapikfs library (static) ?

yep, forgot to add that one.., thanks

jirka
