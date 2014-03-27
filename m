Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaC0X5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 19:57:33 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:34407 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbaC0X5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 19:57:31 -0400
Message-ID: <1395964649.2510.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/3] Minor fixes around perf bench
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Thu, 27 Mar 2014 16:57:29 -0700
In-Reply-To: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
References: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-27 at 19:50 -0400, Ramkumar Ramachandra wrote:
> Hi,
> 
> I just started looking at 'perf bench' this afternoon. Here are some
> simple patches fixing the minor issues I had while starting out.
> 
> Thanks.
> 
> Ram
> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Ramkumar Ramachandra (3):
>   perf bench: Set more defaults in the 'numa' suite
>   perf bench: Update manpage to mention numa and futex
>   perf bench: Fix segfault at the end of an 'all' execution

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

