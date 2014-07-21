Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaGUMff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:35:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbaGUMfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:35:33 -0400
Date: Mon, 21 Jul 2014 14:35:13 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
Message-ID: <20140721123513.GA14929@krava.redhat.com>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <53CCB6AE.6020505@intel.com>
 <20140721080219.GA4183@krava.redhat.com>
 <53CCD3A7.5070002@intel.com>
 <20140721095415.GB8865@krava.redhat.com>
 <53CD02E3.6090509@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CD02E3.6090509@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 03:09:07PM +0300, Adrian Hunter wrote:

SNIP

> >>
> >> ...so is the 100MB limit needed at all if you have ROUND
> >> events?
> > 
> > for data files captured without the ROUND events fix
> 
> I am not sure it should be the default then, if it is
> not needed going forward.

I'd be ok with not setting 100MB limit by default, just need a way
to configure it.. so without following patch:
  perf tools: Limit the ordered events queue by default to 100MB

jirka
