Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaJBVrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:47:39 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:56763 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbaJBVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:47:37 -0400
Message-ID: <1412286455.2877.2.camel@x41>
Subject: Re: cpufreq v3.17-rc7 error: "cpufreq: cpufreq_resume: Failed to
 start governor for policy: f6909a00"
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 23:47:35 +0200
In-Reply-To: <6111663.iIs1ITIHKP@vostro.rjw.lan>
References: <1412250350.3060.9.camel@x41>
	 <2550705.C9YWxWdtP6@vostro.rjw.lan> <1412267608.19413.68.camel@x220>
	 <6111663.iIs1ITIHKP@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2014 21:47:35.0439 (UTC) FILETIME=[7A3831F0:01CFDE8A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schreef op do 02-10-2014 om 19:34 [+0200]:
> On Thursday, October 02, 2014 06:33:28 PM Paul Bolle wrote:
> > On Thu, 2014-10-02 at 18:38 +0200, Rafael J. Wysocki wrote:
> > > Can you please try linux-pm.git/linux-next?  There's a commit from Viresh in
> > > there with a chance to fix this and which I'm going to push to Linus shortly?
> > 
> > Do you mean b1b12babe3b72cfb08b875245e5a5d7c2747c772 ("cpufreq: update
> > 'cpufreq_suspended' after stopping governors")? Does that require
> > anything else from that tree? It doesn't matter much, but if possible I
> > would prefer to add as few patches as I can get away with.
> 
> Yes, that's the commit.  It should work alone too.

Applies and builds cleanly on top of v3.17-rc7. Light testing (two
suspend and resume cycles and one hibernate and thaw cycle) doesn't
trigger the error.

So that commit works for this ThinkPad X41 too, it seems.


Paul Bolle

