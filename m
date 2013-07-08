Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab3GHQrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:47:35 -0400
Received: from mail-ye0-f170.google.com ([209.85.213.170]:57642 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3GHQre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:47:34 -0400
Date: Mon, 8 Jul 2013 13:47:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Greg Price <price@mit.edu>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2] perf report/top: Add option to collapse undesired
 parts of call graph
Message-ID: <20130708164726.GB3028@ghostprotocols.net>
References: <20130701142841.GE22203@biohazard-cafe.mit.edu>
 <20130707131340.GA23433@krava.brq.redhat.com>
 <20130708115746.GO22203@biohazard-cafe.mit.edu>
 <20130708162452.GB2957@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708162452.GB2957@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 08, 2013 at 06:24:52PM +0200, Jiri Olsa escreveu:
> On Mon, Jul 08, 2013 at 07:57:46AM -0400, Greg Price wrote:
> > For example, in an application with an expensive function
> > implemented with deeply nested recursive calls, the default
> > call-graph presentation is dominated by the different callchains
> > within that function.  By ignoring these callees, we can collect the
> > callchains leading into the function and compactly identify what to
> > blame for expensive calls.
 
> change looks ok, but I'm not that confident in this part, so at least:
 
> Tested-by: Jiri Olsa <jolsa@redhat.com>

Thanks, applied.

- Arnaldo
