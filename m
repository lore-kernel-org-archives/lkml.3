Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab3ENVUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:20:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab3ENVUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:20:30 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=K9uRuNqwL0EA:10 a=D19gQVrFAAAA:8 a=R-JOMh6bffYzozB12A0A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368566427.6828.58.camel@gandalf.local.home>
Subject: Re: V3.10-rc1 memory leak
From: Steven Rostedt <rostedt@goodmis.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 14 May 2013 17:20:27 -0400
In-Reply-To: <5192A847.1000100@lwfinger.net>
References: <51912567.6090507@lwfinger.net>
	 <1368558586.6828.53.camel@gandalf.local.home>
	 <20130514203028.GA2997@MacBook-Pro.local> <5192A847.1000100@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 16:10 -0500, Larry Finger wrote:
> On 05/14/2013 03:30 PM, Catalin Marinas wrote:
> >
> > I just got a patch today:
> >
> > https://lkml.org/lkml/2013/5/10/607
> >
> > which could be related. If Rusty doesn't push it I'll do. But please let
> > me know if it does not solve the problem.
> 
> This patch fixes my problem. Now I can see the next new problem reported by 
> kmemleak. :)
> 
> Thanks to you and Jianpeng Ma,
> 
> Larry
> 

It goes away on my testing too. So you can add:

Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


