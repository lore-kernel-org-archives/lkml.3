Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3IWJ1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:27:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46107 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab3IWJ1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:27:10 -0400
Date: Mon, 23 Sep 2013 11:26:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: Use per-file CFLAGS in Makefile
Message-ID: <20130923092659.GD2527@pd.tnic>
References: <1379297476-20793-1-git-send-email-namhyung@kernel.org>
 <20130920230132.GK9574@pd.tnic>
 <878uynrjaa.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <878uynrjaa.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 06:15:09PM +0900, Namhyung Kim wrote:
> I replaced them to a single -w option since all we want to do is
> suppress any warning, right?

Do we? And besides, -w is a big hammer as it shuts up all warnings.
acme?

I think special handling those files grew out of necessity to shut up
some warnings but acme would know better.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
