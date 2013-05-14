Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3ENLFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:05:41 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37530 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3ENLFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:05:40 -0400
MIME-Version: 1.0
In-Reply-To: <1368497347-9628-9-git-send-email-namhyung@kernel.org>
References: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
	<1368497347-9628-9-git-send-email-namhyung@kernel.org>
Date: Tue, 14 May 2013 14:05:38 +0300
X-Google-Sender-Auth: gTXbFl6lbJLMV7x1pMBeIaqyNuU
Message-ID: <CAOJsxLF+4D68oQrcWXyzFgHBcXv4nLvmnSQyCiEYN2CMpRv48Q@mail.gmail.com>
Subject: Re: [PATCH 8/9] perf report: Add report.percent-limit config variable
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 5:09 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> Now an user can set a default value of --percent-limit option into the
> perfconfig file.
>
>   $ cat ~/.perfconfig
>   [report]
>   percent-limit = 0.1
>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

I'm not totally convinced this is useful. The limit is about "what is
significant" and that depends on what you are trying to measure.
There's an (absolute) lower limit somewhere between 0.1 and 1.0 but I
think we can just pick a reasonable default and  let people use the
command line switch if they want to override it.

                        Pekka
