Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3FXIc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:32:59 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:64121 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3FXIc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:32:58 -0400
Date: Mon, 24 Jun 2013 10:32:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Greg Price <price@mit.edu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20130624083253.GA28025@gmail.com>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
 <20130623031720.GW22203@biohazard-cafe.mit.edu>
 <20130623215327.GA995@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623215327.GA995@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> It could also make sense to allow sorting on this
> the same way as we do for '-s parent' and report only
> '[other]' and 'blackbox' entries.
> 
> Also I dont like the 'blackbox' option name, it should
> complement the parent option somehow.. but no idea ;-)

Looks like a nice feature.

Maybe calling it '--collapse' would be a better name?

By default the call-graphs are all expanded to maximum. With this option 
certain function(s) and all their child chains can be collapsed.

--parent filters the call-chains, excluding all others that don't include 
this parent. It might make sense to rename it to --filter?

It would also be nice if all these visualization variants were available 
in the GTK front-end.

Thanks,

	Ingo
