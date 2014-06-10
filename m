Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaFJNML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:12:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37329 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaFJNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:12:08 -0400
Date: Tue, 10 Jun 2014 15:12:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line
 argument for sleep state enumeration
Message-ID: <20140610131206.GA7626@amd.pavel.ucw.cz>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan>
 <2280756.TV3GPFuASb@vostro.rjw.lan>
 <1579932.qSkFQPvI6f@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579932.qSkFQPvI6f@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> On some systems the platform doesn't support neither
> PM_SUSPEND_MEM nor PM_SUSPEND_STANDBY, so PM_SUSPEND_FREEZE is the
> only available system sleep state.  However, some user space frameworks
> only use the "mem" and (sometimes) "standby" sleep state labels, so
> the users of those systems need to modify user space in order to be
> able to use system suspend at all and that is not always possible.

I'd say we should fix the frameworks, not add option to change kernel
interfaces.

Because, as you mentioned, if we add this, we are probably going to
get stuck with it forever :-(.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
