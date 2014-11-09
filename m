Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaKIEa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 23:30:26 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56217 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751263AbaKIEaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 23:30:24 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19/BuFEd1mK8bYlEiMADFzkURv07a2ayA4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 426836155F7
Date: Sat, 8 Nov 2014 23:30:10 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, linux-sh@vger.kernel.org, arnd@arndb.de,
        f.fainelli@gmail.com, ralf@linux-mips.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V4 00/14] genirq endian fixes; bcm7120/brcmstb IRQ
 updates
Message-ID: <20141109043010.GR3698@titan.lakedaemon.net>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
 <20141107122745.GJ3698@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107122745.GJ3698@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 07:27:45AM -0500, Jason Cooper wrote:
> Thomas,
> 
> On Thu, Nov 06, 2014 at 10:44:15PM -0800, Kevin Cernekee wrote:
> > V3->V4:
> > 
> >  - Fix buildbot bisectability warning on patch 02/14 (missing include)
> 
> Dammit.  :(  Even if I had created a topic branch for this series, I
> still would have put the genirq changes in /core, then based a brcm
> branch off of that.
> 
> I'm inclined to think I should just drop v3 and apply v4, as a revert
> commit wouldn't solve the bisectability issue.

Ok, no complaints, so it's done.

thx,

Jason.
