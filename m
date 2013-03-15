Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3COMvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:51:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab3COMvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:51:31 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XS9J8YfiqEIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=djQqxrKAXsQA:10 a=VwQbUJbxAAAA:8 a=TzdKjkQojqi4YbfccNUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363351889.25967.51.camel@gandalf.local.home>
Subject: Re: [PATCH v2] tracing: Expose event tracing infrastructure
From: Steven Rostedt <rostedt@goodmis.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Fri, 15 Mar 2013 08:51:29 -0400
In-Reply-To: <CACV3sb+DqAsQtvK0d+vNHCyeJYCqWD29AyikRCV6g-rZp3A8nQ@mail.gmail.com>
References: <514057BF.6040804@huawei.com>
	 <CACV3sb+DqAsQtvK0d+vNHCyeJYCqWD29AyikRCV6g-rZp3A8nQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 20:31 +0800, Jovi Zhang wrote:

> Hi steven,
> 
> Would you please give some comments? patch works normally on my box.

Yeah, I planned on it today ;-)  Actually, I've been a busy beaver
lately. The last couple of weeks I have:

  32 files changed, 5239 insertions(+), 1805 deletions(-)

(Although some of that work started back last August)

I still have to finish backporting the patches I said I would take from
you from earlier this week.

Anyway, a quick scan of the patch looks fine, and I don't see any major
issues with it. The only problem is that the changes I've made have
touched this code a bit and your patch won't apply, with my new work.

I'm just about finished, the final tests I'm doing on my code are
looking good and I'm hoping to push my final version to linux-next
today. If you want to have a head start, you can look at the current
code (no guarantee that it wont rebase), at:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
 trace/tip/perf/core-5

-- Steve


