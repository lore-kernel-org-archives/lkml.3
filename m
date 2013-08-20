Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3HTQnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:43:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3HTQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:43:50 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=RC9oWFIOW3cA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=1XWaLZrsAAAA:8 a=GVDPHzRvCvcZffxGVgMA:9 a=CjuIK1q_8ugA:10 a=UTB_XpHje0EA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 20 Aug 2013 12:43:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Hugh Dickins <hughd@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/34] 3.4.59-stable review
Message-ID: <20130820124348.349130b2@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1308200913450.1297@eggly.anvils>
References: <20130818203259.653403173@linuxfoundation.org>
	<52125DA9.3090601@samsung.com>
	<20130819193538.GB24897@kroah.com>
	<201308192214.54917.s.L-H@gmx.de>
	<52129AC3.5020402@samsung.com>
	<20130819223037.GA3838@kroah.com>
	<1DC40B07CD6EC041A66726C271A73AE61AA6B9CC@IRSMSX102.ger.corp.intel.com>
	<20130820152401.GA5211@kroah.com>
	<alpine.LNX.2.00.1308200851190.991@eggly.anvils>
	<20130820160355.GA9427@kroah.com>
	<alpine.LNX.2.00.1308200913450.1297@eggly.anvils>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 09:25:05 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

 
> > 
> > Especially as I just did the releases...
> 
> Oh.  Classic case of a patch rushed too quickly into late rc,
> then too quickly from there to stable.
> 

I think we should focus more on having a correct fix than a quick fix
and rush it into mainline. I was criticized for pushing a rather
complex fix into -rc4, and was told that I should wait to 3.12. The
thing is, we had various versions of a fix by -rc1, but I wasn't
satisfied with it. After several rounds we were finally happy with the
fix and by that time, -rc4 was out. I pushed it regardless, as why
should I wait to 3.12 and then push it to stable? We all took our time,
tested the hell out of it (although not as much as it would get going
mainline), had it in linux-next for several days, knew the bug inside
and out and then when we were happy, added it to mainline. I didn't
really care what -rc it was, because it was to go to stable too. Several
patches are still being queued for 3.10. Oh, which I should push out,
as I got distracted by my day job ;-)

Maybe it would be good to discuss when things should go into -rc and
stable at Kernel Summit.

-- Steve
