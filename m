Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaFFNJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:09:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:51538 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaFFNJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:09:05 -0400
Date: Fri, 6 Jun 2014 10:08:54 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip  0/4] perf/probe: Improve error messages
Message-ID: <20140606130854.GI3696@kernel.org>
References: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 06, 2014 at 07:13:38AM +0000, Masami Hiramatsu escreveu:
> Here is a series that improves error messages of perf probe.
> 
>  -  Improve the error message if we can not find given member in
>     the given structure. (perf probe --add)
>  -  Show error code and description only in verbose mode if
>     perf probe command is failed.
>  -  Improve error messages of perf probe --vars mode.
>  -  Improve error messages of perf probe --line mode.
> 
> This series is mainly for fixing confusing messages and
> for removing the error code which is just a mysterious
> number for users.

Thanks, its better now!

Jiri, I'll process these patches,

- Arnaldo
