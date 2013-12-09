Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092Ab3LIKrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:47:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab3LIKr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:47:29 -0500
Date: Mon, 9 Dec 2013 11:47:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/14] tools lib traceevent: Get rid of *die() calls
 from parse-filter.c
Message-ID: <20131209104718.GG1242@krava.brq.redhat.com>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 02:33:57PM +0900, Namhyung Kim wrote:
> Hello,

SNIP

> 
>  tools/lib/traceevent/event-parse.h  |   3 +-
>  tools/lib/traceevent/parse-filter.c | 432 +++++++++++++++++++++++++-----------

I guess we have plans to actualy use parse-filter.c right? ;-)

AFAICS currently there's no user and could (should?) be omited
from compilation

jirka

>  2 files changed, 303 insertions(+), 132 deletions(-)
> 
> -- 
> 1.7.11.7
> 
