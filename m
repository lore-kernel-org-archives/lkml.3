Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3FWV7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab3FWV7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:59:37 -0400
Date: Sun, 23 Jun 2013 23:58:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
Message-ID: <20130623215854.GB995@krava.redhat.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 04:20:40PM +0200, Stephane Eranian wrote:
> This patch series extends perf_events with the ability to sample
> physical data addresses. This is useful with the memory access
> sampling mode added just recently. In particular, it helps
> disambiguate data addresses between two processes, such as
> in the case of a shared memory segment mapped at different
> addresses in different processes.

hi,
what is this patchset based on?
I cannot apply this on tip nor on acme's tree.

thanks,
jirka
