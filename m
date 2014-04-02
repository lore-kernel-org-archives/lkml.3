Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaDBEYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 00:24:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:58580 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbaDBEYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 00:24:00 -0400
Message-ID: <1396412608.1394.15.camel@pasglop>
Subject: Re: [PATCH REPOST v5 1/3] powernv, cpufreq: Select CPUFreq related
 Kconfig options for powernv
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linuxppc-dev@ozlabs.org,
        Linux PM list <linux-pm@vger.kernel.org>, svaidy@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, Anton Blanchard <anton@samba.org>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Apr 2014 15:23:28 +1100
In-Reply-To: <1506880.SKUfks4BOU@vostro.rjw.lan>
References: <CAKohpo=jvswNPmUPEbS79bSp9ZWC1e3DjaEUX=O4CWMXfufHrw@mail.gmail.com>
	 <1396336408-20954-3-git-send-email-ego@linux.vnet.ibm.com>
	 <1396345609.28055.7.camel@pasglop> <1506880.SKUfks4BOU@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 00:03 +0200, Rafael J. Wysocki wrote:
> > Rafael, are you going to take these or should I send them to Linus ?
> > 
> > (I'd rather you take them :-)
> 
> I can do that, but the timing is pretty bad.  How urgent are they?

To be honest pretty urgent. It's a new drop-in driver so it shouldn't
be a huge deal.

We have distros really waiting for this to hit upstream... But I'll
leave that decision to you :-)

Cheers,
Ben.


