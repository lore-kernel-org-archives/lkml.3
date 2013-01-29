Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3A2G0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:26:51 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:43851 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab3A2G0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:26:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130129053308.GB1083@core.coreip.homeip.net>
References: <20130128204424.a3eedfee954ba6cc7a620652@canb.auug.org.au>
	<20130128144615.GC2997@kroah.com>
	<20130128173330.GA11769@core.coreip.homeip.net>
	<CADwDc1AVOaA0N9evbR7A14udx+TRRQo6t_X_Nn15BdEEByupkg@mail.gmail.com>
	<20130128224443.GA1083@core.coreip.homeip.net>
	<20130128235916.GA3124@leaf>
	<20130129002357.GA4420@core.coreip.homeip.net>
	<20130129051321.GB3283@leaf>
	<20130129053308.GB1083@core.coreip.homeip.net>
Date: Mon, 28 Jan 2013 22:26:47 -0800
Message-ID: <CADwDc1CbNeDSNKDh0a01Nde7Mpz3xT6XpsTY4nui8DVt6M40Mw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the tty tree with the input tree
From: Joe Millenbach <jmillenbach@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Bruce Beare <bruce.j.beare@intel.com>,
        Tom Keel <thomas.keel@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jamey Sharp <jamey@minilop.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 9:33 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Please revert the input changes and add *ONE* new dependency to the
> serport driver.
>
> Thanks.
>
> --
> Dmitry

Apologies on this.  I must have misunderstood the problem originally,
and I definitely misunderstood your solution until I looked at it
again.  I just went through applying the changes I'd created minus the
driver/input changes, plus your SERPORT TTY dependency.  You were
right that it solves the dependency issue and is much more elegant.  I
thought it was going to leave dangling select dependencies for users
to deal with later.  Sorry I was so hesitant at first.

I'll be making up a new patch for Greg after I get it reviewed.  And
thank you for your help and persistence in this, Dmitry.

- Joe
