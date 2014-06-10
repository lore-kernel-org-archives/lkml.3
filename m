Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaFJPGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:06:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55466 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751088AbaFJPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:06:00 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line argument for sleep state enumeration
Date: Tue, 10 Jun 2014 17:23:24 +0200
Message-ID: <1848200.GDD9x0Rptb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140610131206.GA7626@amd.pavel.ucw.cz>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan> <1579932.qSkFQPvI6f@vostro.rjw.lan> <20140610131206.GA7626@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 03:12:06 PM Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > On some systems the platform doesn't support neither
> > PM_SUSPEND_MEM nor PM_SUSPEND_STANDBY, so PM_SUSPEND_FREEZE is the
> > only available system sleep state.  However, some user space frameworks
> > only use the "mem" and (sometimes) "standby" sleep state labels, so
> > the users of those systems need to modify user space in order to be
> > able to use system suspend at all and that is not always possible.
> 
> I'd say we should fix the frameworks, not add option to change kernel
> interfaces.
> 
> Because, as you mentioned, if we add this, we are probably going to
> get stuck with it forever :-(.

Unfortunately, fixing the frameworks is rather less than realistic in any
reasonable time frame, since  Android. :-)

Rafael

