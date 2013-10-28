Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3J1Q77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:59:59 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62311 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3J1Q74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:59:56 -0400
Message-ID: <526E9808.4030607@gmail.com>
Date: Mon, 28 Oct 2013 10:59:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@iki.fi>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "hegdevasant@linux.vnet.ibm.com" <hegdevasant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "anton@redhat.com" <anton@redhat.com>,
        "systemtap@sourceware.org" <systemtap@sourceware.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "aravinda@linux.vnet.ibm.com" <aravinda@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com> <F53BA283-A194-4057-8409-27FD3ECFDF2E@iki.fi> <526A8C2B.7000401@gmail.com> <526E24EA.2040701@iki.fi>
In-Reply-To: <526E24EA.2040701@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 2:48 AM, Pekka Enberg wrote:
> So I really hope this SDT effort and the ktap effort at least
> make some effort in unifying all the nice functionality that's
> simple to use and easy to discover. I really, really would
> at the end of the day, just 'perf trace' like I 'perf stat' or
> 'perf record'.

Agree. I see user's eyes glaze over with each command line option, and 
we have added aliases to embed some of the details as well as having 
sensible defaults.

I often use perf-list to lookup an exact event name, and I do not want 
to see it taking many seconds to minutes to run (not everyone is running 
on an SSD). I also run perf on many different OS versions with an NFS 
home directory, and do not want to see a cache explosion (I have buildid 
disabled for this reason).

David

