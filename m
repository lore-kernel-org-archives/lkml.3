Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3APPo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:44:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28818 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3APPo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:44:26 -0500
X-Authority-Analysis: v=2.0 cv=e+OEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=oS6VeJ3zRZwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ylgaL1uFd_sA:10 a=DQFY4bBbQHZdff4M-pYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358351064.4068.43.camel@gandalf.local.home>
Subject: Re: [PATCH 00/10] TTY: switch flipping functions to tty_port
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org
Date: Wed, 16 Jan 2013 10:44:24 -0500
In-Reply-To: <50F6AD15.708@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
	 <20130116064735.GA7743@kroah.com> <50F6AD15.708@suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 14:37 +0100, Jiri Slaby wrote:
> On 01/16/2013 07:47 AM, Greg KH wrote:
> > On Thu, Jan 03, 2013 at 03:53:00PM +0100, Jiri Slaby wrote:
> >> In this series we get rid of the tty_port_tty_get in most hot paths as
> >> all the flipping functions needs to know is in tty_port already. This
> >> simplifies the code at some places a lot.
> >>
> >> Two fixes for coverity issues are included.
> > 
> > All applied, but the drivers/staging/sb105x/ driver is now broken, can
> > you send me a follow-on patch to fix it?
> 
> I intentionally ignored that one as at the time of sending the patches,
> it was marked as BROKEN in -next. It is still broken, since it does not
> even have a tty_port for each port which is a requirement for a while
> already. That is also a prerequisite to fix the build failure.

What do I need to do to fix it?

> 
> Steven, do you have any plans with the driver? What is its planned destiny?

Well, I'm currently using the device in my main machine. As it is my
main box, I don't update the kernel as often.

Let me know what I need to do to fix it in the current kernel.

Thanks,

-- Steve


