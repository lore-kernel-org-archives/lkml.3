Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3FYRbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:31:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15675 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3FYRbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:31:13 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=IBCtqPlELvHzRKiwlVwA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372181471.18733.223.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Tue, 25 Jun 2013 13:31:11 -0400
In-Reply-To: <20130625172609.GA17050@redhat.com>
References: <20130623160452.GA11740@redhat.com>
	 <20130624020014.GB12811@redhat.com> <20130624143928.GA20659@redhat.com>
	 <1372085549.18733.162.camel@gandalf.local.home>
	 <20130624160012.GB5993@redhat.com>
	 <1372091079.18733.168.camel@gandalf.local.home>
	 <20130624165140.GB8572@redhat.com>
	 <1372093476.18733.170.camel@gandalf.local.home>
	 <20130625165556.GA16170@redhat.com>
	 <1372180890.18733.217.camel@gandalf.local.home>
	 <20130625172609.GA17050@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 13:26 -0400, Dave Jones wrote:

>  > Not sure how that would mess up. The ring-buffer code has lots of
>  > integrity checks to make sure nothing like this breaks.
> 
> My integrity checks can beat up your integrity checks.

I don't know. It looks like my code is beating up yours ;-)

-- Steve


