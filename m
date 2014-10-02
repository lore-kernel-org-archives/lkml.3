Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaJBROi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:14:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52583 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751926AbaJBROh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:14:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: cpufreq v3.17-rc7 error: "cpufreq: cpufreq_resume: Failed to start governor for policy: f6909a00"
Date: Thu, 02 Oct 2014 19:34:36 +0200
Message-ID: <6111663.iIs1ITIHKP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412267608.19413.68.camel@x220>
References: <1412250350.3060.9.camel@x41> <2550705.C9YWxWdtP6@vostro.rjw.lan> <1412267608.19413.68.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 02, 2014 06:33:28 PM Paul Bolle wrote:
> On Thu, 2014-10-02 at 18:38 +0200, Rafael J. Wysocki wrote:
> > Can you please try linux-pm.git/linux-next?  There's a commit from Viresh in
> > there with a chance to fix this and which I'm going to push to Linus shortly?
> 
> Do you mean b1b12babe3b72cfb08b875245e5a5d7c2747c772 ("cpufreq: update
> 'cpufreq_suspended' after stopping governors")? Does that require
> anything else from that tree? It doesn't matter much, but if possible I
> would prefer to add as few patches as I can get away with.

Yes, that's the commit.  It should work alone too.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
