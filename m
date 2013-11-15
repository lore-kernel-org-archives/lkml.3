Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3KOF26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:28:58 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56513 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3KOF2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:28:44 -0500
Date: Fri, 15 Nov 2013 06:28:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf top: Make -g refer to callchains
Message-ID: <20131115052839.GA4514@gmail.com>
References: <1384487490-6865-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384487490-6865-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> --- a/tools/perf/Documentation/perf-top.txt
> +++ b/tools/perf/Documentation/perf-top.txt
> @@ -143,12 +142,12 @@ Default is to monitor all CPUS.
>  --asm-raw::
>  	Show raw instruction encoding of assembly instructions.
>  
> --G::
> +-g::
>  	Enables call-graph (stack chain/backtrace) recording.
>  
>  --call-graph::
>  	Setup and enable call-graph (stack chain/backtrace) recording,
> -	implies -G.
> +	implies -g.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
