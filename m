Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3A2X1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:27:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3A2X1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:27:05 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=OLIAMfPGrDAA:10 a=VwQbUJbxAAAA:8 a=ItFxqqEwHeUvkuSjQ8cA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359502022.17639.81.camel@gandalf.local.home>
Subject: Re: About 2.6.38.X-rt
From: Steven Rostedt <rostedt@goodmis.org>
To: Zhenjiao Lu <luzhenjiao@gmail.com>
Cc: stable-rt@vger.kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Jan 2013 18:27:02 -0500
In-Reply-To: <CAPxaQjU_gYfSZ+6=7U4mf=2suNwy3iKOBukCEp6UodzBM03_jw@mail.gmail.com>
References: <CAPxaQjU_gYfSZ+6=7U4mf=2suNwy3iKOBukCEp6UodzBM03_jw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 18:37 +0800, Zhenjiao Lu wrote:
> Dear Madam/Sir,
>  
> Hello & Greetings from China.
>  
> I am a college student in China, now working on the thesis paper,
> which is about the performance of Real Time Linux on embedded devices.
> And I am quite a freshmen in Linux.
>  
> I searched on the Website
> http://www.kernel.org/pub/linux/kernel/projects/rt/ , but
> unfortunately I couldn't find the right rt patch for kernel version
> 2.6.38. So I am writing to inquire if there is a substitute
> or compatible patch version for 2.6.38 version? Please help me and I
> will be waiting for your kind reponse.


Hi,

I'm sorry but we never pushed out a 2.6.38. Things got stuck at 2.6.33
as redesigns in the kernel cause major changes needed in the -rt patch.

Your best bet is to start with the 3.0 kernel, and try to backport that.
Note, 3.0 is really just a fancy name for 2.6.40. Where 2.6.40 is only
two versions passed 2.6.38.

Good luck,

-- Steve


