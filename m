Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaDAVrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:47:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57409 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751865AbaDAVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:47:19 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linuxppc-dev@ozlabs.org,
        Linux PM list <linux-pm@vger.kernel.org>, svaidy@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, Anton Blanchard <anton@samba.org>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST v5 1/3] powernv, cpufreq: Select CPUFreq related Kconfig options for powernv
Date: Wed, 02 Apr 2014 00:03:07 +0200
Message-ID: <1506880.SKUfks4BOU@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396345609.28055.7.camel@pasglop>
References: <CAKohpo=jvswNPmUPEbS79bSp9ZWC1e3DjaEUX=O4CWMXfufHrw@mail.gmail.com> <1396336408-20954-3-git-send-email-ego@linux.vnet.ibm.com> <1396345609.28055.7.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 01, 2014 08:46:49 PM Benjamin Herrenschmidt wrote:
> On Tue, 2014-04-01 at 12:43 +0530, Gautham R. Shenoy wrote:
> > From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
> > 
> > Enable CPUFreq for PowerNV. Select "performance", "powersave",
> > "userspace" and "ondemand" governors. Choose "ondemand" to be the
> > default governor.
> 
> Rafael, are you going to take these or should I send them to Linus ?
> 
> (I'd rather you take them :-)

I can do that, but the timing is pretty bad.  How urgent are they?

Rafael

