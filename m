Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966455AbaFSXwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:52:22 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:52762 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965771AbaFSXwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <1403178338.20417.6.camel@buesod1.americas.hpqcorp.net>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
 <1402942467-10671-2-git-send-email-davidlohr@hp.com> <877g4d8lye.fsf@sejong.aot.lge.com>
 <1403178338.20417.6.camel@buesod1.americas.hpqcorp.net>
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 19 Jun 2014 23:51:59 +0000
X-Google-Sender-Auth: lz7XRUiSJ3hJsdL94LzFyPpkiUI
Message-ID: <CAM9d7cgPhffEX3-AKnXtzgxeT_21hPBjWDsAT1LPu6S=T9VZ_A@mail.gmail.com>
Subject: Re: [PATCH 1/9] perf bench: Add --repeat option
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        mitake@dcl.info.waseda.ac.jp, Aswin Chandramouleeswaran <aswin@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On Thu, Jun 19, 2014 at 11:45 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> Hi Namhyung,
>
> On Thu, 2014-06-19 at 15:14 +0900, Namhyung Kim wrote:
>> By adding a top-level option, I think it should be applied to all
>> benchmaks - but I guess it only supports sched messaging and futex,
>> right?
>
> Yes, for now only those. While there is opportunity for others to use it
> as well (perhaps shed-pipe & memcpy/memset), I don't think *all*
> benchmarks need multiple runs, ie: numa.

Hmm.. but it'd make users confusing if one runs the numa benchmark
with -r 5 option but it only do a single run..

Thanks,
Namhyung
