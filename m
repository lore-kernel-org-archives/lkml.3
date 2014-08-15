Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116AbaHONwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:52:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:37332 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaHONwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:52:14 -0400
Date: Fri, 15 Aug 2014 10:52:09 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [RFC/PATCHSET 0/3] perf tools: Callchain improvement with
 --children and -g caller
Message-ID: <20140815135209.GE3508@kernel.org>
References: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 14, 2014 at 03:01:37PM +0900, Namhyung Kim escreveu:
> Hello,
> 
> This patchset tries to improve the callchain behavior when caller
> ordering (which is not default) and --children (which is default)
> enabled.  I think that we might need to change default to caller
> ordering when --children is enabled - but it needs more discussion of
> course.

Applied the first one, waiting for a conclusion to the discussion with
Jiri to process the other two.

- Arnaldo
