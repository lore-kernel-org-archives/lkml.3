Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3APS3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:29:45 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:57782 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3APS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:29:44 -0500
Date: Wed, 16 Jan 2013 15:29:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/13] perf report: Add support for event group view
 (v8)
Message-ID: <20130116182937.GP5826@ghostprotocols.net>
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
 <20130115183858.GF5826@ghostprotocols.net>
 <87622xmn73.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87622xmn73.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 16, 2013 at 07:33:52PM +0900, Namhyung Kim escreveu:
> On Tue, 15 Jan 2013 15:38:58 -0300, Arnaldo Carvalho de Melo wrote:
> > It would be great if examples of this in use were provided.

> > Detailed ones at that, showing how things were in the past, how the info
> > can be retrieved when using 'perf report --stdio', perhaps 'perf evlist'
> > can show the stored group information too, how the 'perf report' output
> > looks like when showing group info, things like that.

> I think most of aforementioned things were on the initial post.  I
> thought it's too verbose to be contained to the cover letter every time
> so I just put the link.

> But I'll include it next time and work on the perf evlist too.

Thank you!

- Arnaldo
