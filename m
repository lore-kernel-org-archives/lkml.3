Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965624Ab3HHOrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:47:31 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:49185 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965321Ab3HHOr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:47:27 -0400
Date: Thu, 8 Aug 2013 11:39:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] perf kvm: option to print events that exceed a
 duration -v2
Message-ID: <20130808143944.GB2851@ghostprotocols.net>
References: <1375926999-75129-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375926999-75129-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 07, 2013 at 09:56:38PM -0400, David Ahern escreveu:
> This is useful to spot high latency blips. It is normal for HLT
> reasons to have long exit times, so strip those from the duration
> check.
> 
> v2: changed threshold to duration per acme's request

Thanks, applied.
