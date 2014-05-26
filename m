Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaEZVNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:13:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60559 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751525AbaEZVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:13:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] ACPI / LPSS: custom power domain for LPSS
Date: Mon, 26 May 2014 23:30:27 +0200
Message-ID: <2206183.6DSdmh5SWp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140526134234.GA12107@xps8300>
References: <20140523130252.GH18308@xps8300> <11413734.64aCNVobNb@vostro.rjw.lan> <20140526134234.GA12107@xps8300>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 26, 2014 04:42:34 PM Heikki Krogerus wrote:
> On Mon, May 26, 2014 at 03:03:27PM +0200, Rafael J. Wysocki wrote:
> > On Friday, May 23, 2014 04:15:09 PM Heikki Krogerus wrote:
> > > A power domain where we save the context of the additional
> > > LPSS registers. We need to do this or all LPSS devices are
> > > left in reset state when resuming from D3 on some Baytrails.
> > > The devices with the fractional clock divider also have
> > > zeros for N and M values after resuming unless they are
> > > reset.
> > > 
> > > Li Aubrey found the root cause for the issue. The idea of
> > > using power domain for LPSS came from Mika Westerberg.
> > > 
> > > Reported-by: Jin Yao <yao.jin@linux.intel.com>
> > > Suggested-by: Li Aubrey <aubrey.li@linux.intel.com>
> > > Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > 
> > Queued up for 3.16, but I needed to rebase it to take some other changes
> > into account.  Can you please have a look and the bleeding-edge branch in
> > my tree and see if everything looks good in there?
> 
> I checked the bleeding-edge and it looks good to me. Thanks for taking
> care of the issue with "%lx".
> 
> About the sparse warning from the clk-fractional-divider.c. Since
> there is no real issue, let's follow the style in the other clock
> types and ignore the warning. So let's keep that patch as it is. OK?

That's fine by me.

Rafael

