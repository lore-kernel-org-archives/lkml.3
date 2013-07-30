Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3G3OuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:50:21 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52680 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3G3OuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:50:19 -0400
Message-ID: <51F7D2A9.7030803@gmail.com>
Date: Tue, 30 Jul 2013 08:50:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
References: <20130625104700.GZ28407@twins.programming.kicks-ass.net> <20130625105123.GA13649@gmail.com> <20130626103303.GB28407@twins.programming.kicks-ass.net> <CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com> <20130628095828.GG29209@dyad.programming.kicks-ass.net> <CABPqkBSfkg+rPw4A=n8wmPg=iwn1Qf8PdYA4ycxxooOv3GrvmA@mail.gmail.com> <20130708081919.GV23916@twins.programming.kicks-ass.net> <CABPqkBSesQsfeutY2qu1n3uMka0dOFOT2tzqCWYGV=2p6F8Y9w@mail.gmail.com> <20130730083758.GH3008@twins.programming.kicks-ass.net> <CABPqkBTxovrj11sskW50TZzf6e_V0tObT-qDPAbxHcrpLJNNZg@mail.gmail.com> <20130730090202.GL3008@twins.programming.kicks-ass.net> <CABPqkBRX-A5i26w1aMBmjb7GVmYUBS6k03ePN6qoASS9Z9xkmg@mail.gmail.com> <CABPqkBQeNEidngxK08O-eAA4aJhqe8R-F-8Vk8DA-Z1qtKdU_Q@mail.gmail.com>
In-Reply-To: <CABPqkBQeNEidngxK08O-eAA4aJhqe8R-F-8Vk8DA-Z1qtKdU_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/13 8:21 AM, Stephane Eranian wrote:
> One thing that bothers me with the MMAP2 approach is that
> it forces integration into perf. Now, you will need to analyze
> the MMAP2 records. With my sample_type approach, you
> simply needed a cmdline option on perf record, and then
> you could dump the sample using perf report -D and feed

what do you want that is not coming out via perf-script?

> them into a post-processing script. But now, the analysis
> needs to be integrated into perf or the tool needs to parse
> the full perf.data file.

you mean parsed during perf-record?

David
