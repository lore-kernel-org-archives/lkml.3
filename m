Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934612Ab3FSLdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:33:35 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48812 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934075Ab3FSLdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:33:31 -0400
Date: Wed, 19 Jun 2013 13:33:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 3/3] perf tools: include termios.h explicitly
Message-ID: <20130619113326.GA9119@gmail.com>
References: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> Building perf for android is failed, because it can't find definition of
> struct winsize. This definition is in termios.h, so I add this header
> to util.h to solve the problem. It is missed by commit '2c803e52' which
> moves get_term_dimensions() from builtin-top.c to util.c, but, missed to
> move termios.h header.
> 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Is this something we need for v3.10 as well?

Thanks,

	Ingo
