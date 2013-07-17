Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3GQP3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:29:39 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:63817 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab3GQP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:29:37 -0400
Date: Wed, 17 Jul 2013 12:29:30 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf symbol: Do not apply symfs for an absolute vmlinux
 path
Message-ID: <20130717152930.GB2071@ghostprotocols.net>
References: <1374048495-3643-1-git-send-email-namhyung@kernel.org>
 <51E69CB4.9060905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E69CB4.9060905@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 17, 2013 at 07:31:32AM -0600, David Ahern escreveu:
> On 7/17/13 2:08 AM, Namhyung Kim wrote:
> >From: Namhyung Kim <namhyung.kim@lge.com>
> >
> >If an user gives both of --symfs and --vmlinux option, the vmlinux
> >will be searched under the symfs directory.  This is somewhat
> >confusing since vmlinux often lives in kernel build directory or
> >somewhere other than user space binaries.
> >
> >So it'd be better not adding symfs prefix for a vmlinux if it has an
> >absolute pathname.
> >
> >Reported-by: Kwanghyun Yoo <ykh815.yoo@lge.com>
> >Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> 

Thanks, applied.

- Arnaldo
