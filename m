Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3I0Aih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 20:38:37 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52542 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3I0Aig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 20:38:36 -0400
X-AuditID: 9c93017e-b7ca5ae0000013bb-d5-5244d3880384
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: Use per-file CFLAGS in Makefile
References: <1379297476-20793-1-git-send-email-namhyung@kernel.org>
	<20130920230132.GK9574@pd.tnic> <878uynrjaa.fsf@sejong.aot.lge.com>
	<20130923092659.GD2527@pd.tnic> <87vc1qprny.fsf@sejong.aot.lge.com>
	<20130924170842.GA2634@ghostprotocols.net>
Date: Fri, 27 Sep 2013 09:38:32 +0900
In-Reply-To: <20130924170842.GA2634@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 24 Sep 2013 14:08:42 -0300")
Message-ID: <87r4cbp08n.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 24 Sep 2013 14:08:42 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Sep 24, 2013 at 05:09:21PM +0900, Namhyung Kim escreveu:
>> I don't know.  I just thought there's not much thing we can do for those
>> files other than shutting up all warnings.
>  
>> But if you think that's not the right thing, I'll keep the existing
>> options.  What do you think, Arnaldo?
>
> I think keeping the existing options is the right thing to do, if some
> of that can be simplified or made like you did it in your patch, then
> that is the matter for a separate patch, with proper explanation.

Okay, I'll just keep them and resend v2.

Thanks,
Namhyung
