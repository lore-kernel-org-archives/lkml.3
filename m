Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbaDBKrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:47:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61062 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758086AbaDBKrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:47:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linuxppc-dev@ozlabs.org,
        Linux PM list <linux-pm@vger.kernel.org>, svaidy@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, Anton Blanchard <anton@samba.org>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST v5 1/3] powernv, cpufreq: Select CPUFreq related Kconfig options for powernv
Date: Wed, 02 Apr 2014 13:03:35 +0200
Message-ID: <1621325.cz1O3Ng49e@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396412608.1394.15.camel@pasglop>
References: <CAKohpo=jvswNPmUPEbS79bSp9ZWC1e3DjaEUX=O4CWMXfufHrw@mail.gmail.com> <1506880.SKUfks4BOU@vostro.rjw.lan> <1396412608.1394.15.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 02, 2014 03:23:28 PM Benjamin Herrenschmidt wrote:
> On Wed, 2014-04-02 at 00:03 +0200, Rafael J. Wysocki wrote:
> > > Rafael, are you going to take these or should I send them to Linus ?
> > > 
> > > (I'd rather you take them :-)
> > 
> > I can do that, but the timing is pretty bad.  How urgent are they?
> 
> To be honest pretty urgent. It's a new drop-in driver so it shouldn't
> be a huge deal.
> 
> We have distros really waiting for this to hit upstream... But I'll
> leave that decision to you :-)

Well, I've already sent a second pull request for this merge window
and I'm not going to send the next one before it is merged.

So, I can push them next week realistically.

Rafael

