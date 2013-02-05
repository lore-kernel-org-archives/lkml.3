Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3BETwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:52:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14873 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab3BETwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:52:34 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=3wK-9PESS3wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NUAUlJP6XUYA:10 a=keqEdgRk7o3ePzrr-J0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360093950.2621.1.camel@gandalf.local.home>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@kernel.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org, rbraun@sceen.net,
        zhong@linux.vnet.ibm.com, markus@trippelsdorf.de,
        sasha.levin@oracle.com, cody@linux.vnet.ibm.com,
        dave@linux.vnet.ibm.com, fweisbec@gmail.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Date: Tue, 05 Feb 2013 14:52:30 -0500
In-Reply-To: <20130205141124.GA12785@linux.vnet.ibm.com>
References: <20130204171817.GA18332@linux.vnet.ibm.com>
	 <20130204180734.GA10022@gmail.com> <20130204193041.GA16853@gmail.com>
	 <20130204202523.GZ2632@linux.vnet.ibm.com>
	 <20130205141124.GA12785@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 06:11 -0800, Paul E. McKenney wrote:

> Steven Rostedt (1):
>       rcu: Allow rcutorture to be built at low optimization levels
> 

I wish git had dual (or more) authorship, as I started with your patch
and added on to it. We are really both responsible for that change.

-- Steve


