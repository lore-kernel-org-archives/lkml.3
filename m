Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaEPX64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:58:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54316 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752143AbaEPX6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:58:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mike Turquette <mturquette@linaro.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/4] clk: new basic clk type for fractional divider
Date: Sat, 17 May 2014 02:15:43 +0200
Message-ID: <3823442.HzUarSqr07@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140516230905.9521.88763@quantum>
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com> <1454520.Q33DvSH0ns@vostro.rjw.lan> <20140516230905.9521.88763@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2014 04:09:05 PM Mike Turquette wrote:
> Quoting Rafael J. Wysocki (2014-05-16 15:38:05)
> > On Thursday, May 15, 2014 09:53:49 AM Mike Turquette wrote:
> > > Quoting Heikki Krogerus (2014-05-15 06:40:25)
> > > > Fractional divider clocks are fairly common. This adds basic
> > > > type for them.
> > > > 
> > > > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > 
> > > Taken into clk-next.
> > > 
> > > Just FYI, there was some talk at Embedded Linux Conference on providing
> > > a better abstraction layer for some of these "basic" clock types. This
> > > abstraction would allow the basic clock types to implement the
> > > machine-agnostic logic (e.g. an incoming rate is divided by a value) and
> > > then platforms and drivers could plug in the machine-specific parts
> > > (e.g. divider is made up of m/n, or divider is power-of-two, or divider
> > > is a simple integer with min == 1 and max == 5).
> > > 
> > > All of that is to say that in time this fractional divider could go away
> > > once the abstraction layer allows us to fold the m/n divider stuff into
> > > a core divider implementation.
> > > 
> > > Nothing wrong with the patch for now, so I've taken it for 3.16.
> > 
> > Well, OK, but I guess [4/4] depends on it and [4/4] also depends on
> > [1-2/4], so how you're proposing to resolve this?
> 
> I haven't yet published this patch to my tree, so no harm done. How
> about the following Formal Proposals?
> 
> 1) I ack the patch and don't merge it through my tree. You take it.
> 2) I provide a topic branch that we both merge.
> 
> Your choice.

Thanks!  I'd prefer 1) to be honest. :-)

Rafael

