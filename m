Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaLAHC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:02:29 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53180 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaLAHC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:02:28 -0500
Date: Mon, 1 Dec 2014 12:32:13 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>
Subject: Re: [PATCH] Revert "staging: sm7xxfb: remove driver"
Message-ID: <20141201070213.GA4720@sudip-PC>
References: <20141120170925.5a435436@gandalf.local.home>
 <20141120232329.GA27669@kroah.com>
 <20141122070202.GB4490@sudip-PC>
 <20141122140040.GA28422@kroah.com>
 <20141122162020.GA10957@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141122162020.GA10957@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 09:50:20PM +0530, Sudip Mukherjee wrote:
> On Sat, Nov 22, 2014 at 06:00:40AM -0800, Greg Kroah-Hartman wrote:
> > On Sat, Nov 22, 2014 at 12:32:02PM +0530, Sudip Mukherjee wrote:
> > > 2) most important - I do not have the hardware. So from the TODO list
> > > dual head and 2D acceleration support will be tough without actually
> > > checking on the hardware.
> > 
> > For a driver like this, if you don't have the hardware, I wouldn't
> > recommend taking on the task of trying to fix it up and become the
> > maintainer, sorry.
> ofcourse. that is the reason i mentioned in my mail that i do not have the hardware.
> I am trying to get a SM712 based display card.if i manage to get one i will mail you again.
> 
> thanks
> sudip

Hi Greg K-H,

I have spoken to Teddy Wang of Silicon Motion and he has agreed to give me a SM712 board. He will also be giving his guidance in the code. And we both will be the Maintainer of the code.

I will send you the patch to revert your commit after i have received the board from Teddy Wang and I have done my initial testing.

Just have a few questions, and I hope you can help me with them :-
1) do i need to have git server somewhere to send you pull request or i send you patches?
2) the tree on which i will be working that will be based on which tree : linux-next, staging-next or staging-testing?

I hope you will not mind if I ask for your suggestions whenever i get a doubt (which I will get many), after all i am still a newbie here.

thanks
sudip

> 
> > 
> > greg k-h
