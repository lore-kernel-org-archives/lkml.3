Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3FGD7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:59:52 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52266 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3FGD7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:59:50 -0400
Message-ID: <1370577588.24311.407.camel@edumazet-glaptop>
Subject: Re: NULL pointer dereference when loading the gre module
 (3.10.0-rc4)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 06 Jun 2013 20:59:48 -0700
In-Reply-To: <20130607030648.GA28618@home.goodmis.org>
References: <20130606221656.GA11475@uio.no>
	 <20130607030648.GA28618@home.goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 23:06 -0400, Steven Rostedt wrote:
> On Fri, Jun 07, 2013 at 12:16:56AM +0200, Steinar H. Gunderson wrote:
> > Hi,
> > 
> > In 3.10.0-rc4, I get this on boot:
> > 
> > [   16.871043] BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
> > [   16.879453] IP: [<ffffffffa0e52002>] 0xffffffffa0e52001
> 
> Strange, kallsyms should have registered the address already, even if it
> crashed on early module load. Not sure why it's not reporting it. Well,
> it seems to have reported some of the symbols of ip_gre below. Maybe
> this pointer is just totally screwed up.

I could not reproduce this here.

Steinar, please make sure you recompiled your modules, because this
looks like you loaded old modules.



