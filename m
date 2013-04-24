Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab3DXMdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:33:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab3DXMdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:33:13 -0400
Date: Wed, 24 Apr 2013 14:32:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/14] perf util: Move debugfs/tracing helper functions
 to util.c
Message-ID: <20130424123252.GD971@krava.brq.redhat.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366705872-12132-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366705872-12132-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 05:30:59PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Since they're generic helpers move them to util.c so that they can be
> used by others.

hum, we have sysfs object, maybe we want debugfs
as well to stay consistent.. even with interface:

for sysfs we have:
const char *sysfs_find_mountpoint(void);

for debugfs? :
const char *debugfs_find_mountpoint(void);

or we could unite all of them under fs object
as they are quite small ;-)

jirka
