Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbaDKAcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:32:16 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37860 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaDKAcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:32:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140409121618.GA2556@krava.brq.redhat.com>
References: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
 <1395964219-22173-2-git-send-email-artagnon@gmail.com> <20140409121618.GA2556@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 10 Apr 2014 20:31:32 -0400
Message-ID: <CALkWK0=xjT7tAxGfzQ+6+=sjbtpu865_FKr8ai4tsLVg=CYdGQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf bench: Set more defaults in the 'numa' suite
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
>  ###
>  # 1 task will execute (on 1 nodes, 4 CPUs):
>  #         -1x     1MB global  shared mem operations
>  #         -1x     0MB process shared mem operations
>  #         -1x     0MB thread  local  mem operations
>  ###
> ...
>
>
> '-1x' does not seem right/intentional for default case

As you can see from print_summary(), -1 is the value of nr_loops. In
init_params(), Ingo set nr_loops is set to -1 in his original patch --
I haven't touched that. So, unless I'm missing something, it's quite
an apt default case.

Ram
