Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaAONjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:39:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaAONjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:39:46 -0500
Date: Wed, 15 Jan 2014 14:39:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET 00/17] tools lib traceevent: Plugin unload enhancement
Message-ID: <20140115133915.GB8350@krava.redhat.com>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 10:45:23AM +0900, Namhyung Kim wrote:
> Hello,
> 
> When plugins are loaded, they register various event and function
> handlers.  But they don't unregister even after the plugins unloaded
> so that events could have refererences to non-existing handlers.
> 
> This patchset added relevant unregister functions to handle that.
> 
> Note that this is not a problem as of now since all of users unload
> plugins after finishing their access to events.  But being a generic
> library, it should be handled properly IMHO.
> 
> The patch 1-4 are resend of the previous die removal series so
> independent to this series.
> 
> I put the series on the 'libtraceevent/plugin-v1' branch in my tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Any comments are welcome, thanks
> Namhyung

looks ok,

Reviewed-by: Jiri Olsa <jolsa@redhat.com>

jirka
