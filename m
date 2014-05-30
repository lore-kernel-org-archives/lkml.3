Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaE3NHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:07:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaE3NHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:07:07 -0400
Date: Fri, 30 May 2014 15:06:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.w.shin@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 0/4] perf: Support AMD range breakpoints
Message-ID: <20140530130627.GB7427@krava.brq.redhat.com>
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 05:26:49PM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> I've made it wait too much so I'm posting that for review now. This
> implements range breakpoints on some AMD machine by extending the length
> field.
> 
> Any comment?
hi,
perf tools patches look ok to me.. let me know
if I should queue them

thanks,
jirka
