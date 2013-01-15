Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3AOSjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:39:07 -0500
Received: from mail-gh0-f180.google.com ([209.85.160.180]:49737 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab3AOSjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:39:06 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2013 13:39:06 EST
Date: Tue, 15 Jan 2013 15:38:58 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/13] perf report: Add support for event group view
 (v8)
Message-ID: <20130115183858.GF5826@ghostprotocols.net>
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 15, 2013 at 04:31:44PM +0900, Namhyung Kim escreveu:
> This is my 8th attempt to enable the event group view for perf report.
> For basic idea and usage example, please see my initial post [1].
> 
> This version is rebased on the current acme/perf/core and it's mainly
> changed due to a refactoring of gtk browser.
> 
> You can get this via 'perf/group-v8' branch on my tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Any comments are welcome, thanks,

It would be great if examples of this in use were provided.

Detailed ones at that, showing how things were in the past, how the info
can be retrieved when using 'perf report --stdio', perhaps 'perf evlist'
can show the stored group information too, how the 'perf report' output
looks like when showing group info, things like that.

- Arnaldo
