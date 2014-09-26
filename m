Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaIZPhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:37:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:40991 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbaIZPhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:37:22 -0400
Date: Fri, 26 Sep 2014 12:37:16 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "open list:PERFORMANCE EVENT..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Use ACCESS_ONCE() instead of volatile cast
Message-ID: <20140926153716.GE3879@kernel.org>
References: <1411484109-10442-1-git-send-email-bobby.prani@gmail.com>
 <87zjdpkavo.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjdpkavo.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 24, 2014 at 11:31:07AM +0900, Namhyung Kim escreveu:
> Hi Pranith,
> 
> On Tue, 23 Sep 2014 10:55:08 -0400, Pranith Kumar wrote:
> > Use ACCESS_ONCE() instead of the cast to volatile and read. This is just a style
> > change which is reader friendly.
> >
> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks, applied.
