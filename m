Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3CBEXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:23:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CBEW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:22:59 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dCXt4Z_EDXgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VHl0eERhotoA:10 a=QZLT4aqRdLNKTwHmQDIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362198178.1231.83.camel@gandalf.local.home>
Subject: Re: linux-next: build failure after merge of the ftrace tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Mar 2013 23:22:58 -0500
In-Reply-To: <20130302151700.89f98f5c132a913510b5a621@canb.auug.org.au>
References: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
	 <1362192318.1231.67.camel@gandalf.local.home>
	 <20130302144229.f41f56c36992497a1530d65f@canb.auug.org.au>
	 <1362196529.1231.80.camel@gandalf.local.home>
	 <20130302151700.89f98f5c132a913510b5a621@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 15:17 +1100, Stephen Rothwell wrote:
>  
> > I made some major changes and wanted testing on it as soon as possible.
> > I've done tons of testing on my own but I wanted a broader audience. Do
> > you want me to pull my tree and reset it to what is only for 3.9?
> 
> Yes, please.  The reasoning is that until -rc1 is out we don't want to
> complicate life for people whose code has not yet been merged by
> reporting problems in code that will not be merged until the next merge
> window.

OK, I reset it to what I based my work on, and that commit is in Linus's
tree.

> 
> That is why my daily reports during the merge window start with:
> 
> "Please do not add any work destined for v3.10 to your -next included
> branches until after Linus has release v3.9-rc1."
> 
> But I am beginning to realise that not many actually read those reports (I

/me is guilty :-(

> had the date wrong on two of them this week and it was only noticed after
> the second one :-().
> 

I'm try to be better next time.

-- Steve


