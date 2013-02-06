Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3BFMtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:49:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3BFMtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:49:01 -0500
Date: Wed, 6 Feb 2013 13:48:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/2] perf scripts: Fix rwtop record script
Message-ID: <20130206124840.GA11700@krava.redhat.com>
References: <1360080351-3246-1-git-send-email-jolsa@redhat.com>
 <1360080351-3246-3-git-send-email-jolsa@redhat.com>
 <51113018.80503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51113018.80503@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 09:15:20AM -0700, David Ahern wrote:
> On 2/5/13 9:05 AM, Jiri Olsa wrote:
> >Adding -D option into the rwtop record command line, to get
> >immediate response when there's event in the buffer.
> 
> Seems like this will dramatically increase CPU usage of perf-record
> as well as increase the overhead of each event with a process
> wakeup. How about a poll option on perf-record to have it wake up at
> a given rate instead?

right, I'll check

thanks,
jirka
