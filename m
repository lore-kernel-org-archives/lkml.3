Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3E2AEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:04:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3E2AEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:04:38 -0400
X-Authority-Analysis: v=2.0 cv=IZAFqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ggpWy2Hc9ZsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=dYF8XoAgN1cA:10 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=RYv5n68prgsbPOUVBpkA:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=sokPkLYzTpiCTifp:21 a=v6nRvwi_MIRwWU_c:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369785877.15552.56.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: Fix file mode of free_buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Wang YanQing <udknight@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 28 May 2013 20:04:37 -0400
In-Reply-To: <CAJL_ektFUuXQresgiNoGuDvvGvnF5G8i1wMNG3z8q8aTD4nTUA@mail.gmail.com>
References: <20130526085201.GA3183@udknight>
	 <CAL26m8+baBm-kcWH96C1oj3rVHoa0Vc=gHshqWAD-BtBd4FJKQ@mail.gmail.com>
	 <CAJL_ektFUuXQresgiNoGuDvvGvnF5G8i1wMNG3z8q8aTD4nTUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 13:14 -0700, David Sharp wrote:
> On Tue, May 28, 2013 at 12:34 PM, Vaibhav Nagarnaik
> <vnagarnaik@google.com> wrote:
> > On Sun, May 26, 2013 at 1:52 AM, Wang YanQing <udknight@gmail.com> wrote:
> >> Commit 4f271a2a60c748599b30bb4dafff30d770439b96
> >> (tracing: Add a proc file to stop tracing and free buffer)
> >> implement a method to free up ring buffer in kernel memory
> >> in the release code path of free_buffer's fd.
> >>
> >> Then we don't need read/write support for free_buffer,
> >> indeed we just have a dummy write fop, and don't implement read fop.
> >>
> >> So the 0200 is more reasonable file mode for free_buffer than
> >> the current file mode 0644.
> >>
> >> Signed-off-by: Wang YanQing <udknight@gmail.com>
> >
> > Acked-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> 
> Acked-by: David Sharp <dhsharp@google.com>
> 
> >

Thanks guys,

As this isn't that big of a deal, I'm going to just queue this for 3.11.

-- Steve


