Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbaCDHTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:19:39 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:37505 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaCDHTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:19:38 -0500
Date: Tue, 4 Mar 2014 08:19:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 00/10] perf report: Add -F option for specifying output
 fields
Message-ID: <20140304071934.GA23148@gmail.com>
References: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hello,
> 
> This is a patchset implementing -F/--field option to setup output
> field/column as Ingo requested.
> 
> The -F option can receive any sort keys that -s option recognize, plus
> following fields (name can be changed):
> 
>   overhead, overhead_sys, overhead_us, sample, period
> 
> The overhead_guest_sys and overhead_guest_us might be avaiable when
> you profile guest machines.
> 
> Output will be sorted by in order of fields and sort keys passed by 
> -s option will be added to the output field list automatically.  If 
> you want to change the order of sorting you can give -s option in 
> addition to -F option.  To support old behavior, it'll also prepend 
> 'overhead' field to the sort keys unless you give -F option 
> explicitly.

Very nice!

For the concept:

  Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
