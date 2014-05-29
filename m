Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472AbaE2N4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:56:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:49170 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751AbaE2N4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:56:31 -0400
Date: Thu, 29 May 2014 10:56:27 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix perf probe to find
 correct variable DIE
Message-ID: <20140529135627.GH2764@kernel.org>
References: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <53872A72.6040007@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53872A72.6040007@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 29, 2014 at 09:39:14PM +0900, Masami Hiramatsu escreveu:
> Hi Arnaldo,
> 
> Here is the patch which fixes perf probe to find variable
> location correctly, on the recent dwarf format. This is not
> related to the SEGV issue which I fixed in previous mail.

Thanks for the prompt reply! I'm testing them and will report results
here!

- Arnaldo
