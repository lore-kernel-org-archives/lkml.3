Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbaDBL35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:29:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:37227 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbaDBL3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:29:55 -0400
Message-ID: <1396438160.19206.23.camel@pasglop>
Subject: Re: [PATCH REPOST v5 1/3] powernv, cpufreq: Select CPUFreq related
 Kconfig options for powernv
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linuxppc-dev@ozlabs.org,
        Linux PM list <linux-pm@vger.kernel.org>, svaidy@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, Anton Blanchard <anton@samba.org>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Apr 2014 22:29:20 +1100
In-Reply-To: <1621325.cz1O3Ng49e@vostro.rjw.lan>
References: <CAKohpo=jvswNPmUPEbS79bSp9ZWC1e3DjaEUX=O4CWMXfufHrw@mail.gmail.com>
	 <1506880.SKUfks4BOU@vostro.rjw.lan> <1396412608.1394.15.camel@pasglop>
	 <1621325.cz1O3Ng49e@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 13:03 +0200, Rafael J. Wysocki wrote:
> > To be honest pretty urgent. It's a new drop-in driver so it
> shouldn't
> > be a huge deal.
> > 
> > We have distros really waiting for this to hit upstream... But I'll
> > leave that decision to you :-)
> 
> Well, I've already sent a second pull request for this merge window
> and I'm not going to send the next one before it is merged.
> 
> So, I can push them next week realistically.

Thanks. You can blame me for the lateness if you want (and the debate as
to which tree should carry them :-)

Cheers,
Ben.


