Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3DZNvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:51:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15959 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab3DZNu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:50:59 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LKwk6uaGbn4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=mbomyTfwWgEA:10 a=tB_A-C0Sper_eLvxwS0A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366984256.16752.6.camel@gandalf.local.home>
Subject: Re: [PATCH 05/14] perf tools: Introduce new 'ftrace' tool
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Date: Fri, 26 Apr 2013 09:50:56 -0400
In-Reply-To: <517A827B.1080905@gmail.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	  <1366705872-12132-6-git-send-email-namhyung@kernel.org>
	  <20130424140918.GF971@krava.brq.redhat.com>
	  <87fvyf9maa.fsf@sejong.aot.lge.com>
	  <20130425090956.GA1033@krava.brq.redhat.com>
	  <87r4hz7xal.fsf@sejong.aot.lge.com>
	 <1366895121.10248.12.camel@gandalf.local.home> <517A827B.1080905@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 07:34 -0600, David Ahern wrote:
> On 4/25/13 7:05 AM, Steven Rostedt wrote:
> >   Perf was added in 2.6.31, but do all
> > functionalities still work that far back?
> 
> 
> perf was accepted into 2.6.28 - first commit is 0793a61d.

That's kernel side.

> 
> It does have limited functionality (H/W and S/W counters) until 2.6.31.

The first commit I found by doing "git log tools/perf" and going to the
end was:

864709302a80f26fa9da3be5b47304f0b8bae192

But I now see that was moving perf from documentation to tools, so that
was incorrect. But even going back farther than that, of commit
d24e473e5b2ca86d1288b9416227ccc603313d0f which adds the first
development of perf in the Documentation directory, I still get:

git describe --contains d24e473e5b2ca86d1288b9416227ccc603313d0f
v2.6.31-rc1~383^2~367

I still stand by the fact that perf was not added until 2.6.31.

-- Steve


