Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab3IXIJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:09:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64589 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3IXIJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:09:23 -0400
X-AuditID: 9c930179-b7c8bae000006c65-d9-524148b18d18
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: Use per-file CFLAGS in Makefile
References: <1379297476-20793-1-git-send-email-namhyung@kernel.org>
	<20130920230132.GK9574@pd.tnic> <878uynrjaa.fsf@sejong.aot.lge.com>
	<20130923092659.GD2527@pd.tnic>
Date: Tue, 24 Sep 2013 17:09:21 +0900
In-Reply-To: <20130923092659.GD2527@pd.tnic> (Borislav Petkov's message of
	"Mon, 23 Sep 2013 11:26:59 +0200")
Message-ID: <87vc1qprny.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Mon, 23 Sep 2013 11:26:59 +0200, Borislav Petkov wrote:
> On Mon, Sep 23, 2013 at 06:15:09PM +0900, Namhyung Kim wrote:
>> I replaced them to a single -w option since all we want to do is
>> suppress any warning, right?
>
> Do we? And besides, -w is a big hammer as it shuts up all warnings.
> acme?
>
> I think special handling those files grew out of necessity to shut up
> some warnings but acme would know better.

I don't know.  I just thought there's not much thing we can do for those
files other than shutting up all warnings.

But if you think that's not the right thing, I'll keep the existing
options.  What do you think, Arnaldo?

Thanks,
Namhyung
