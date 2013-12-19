Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3LSTN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:13:29 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:15840 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3LSTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:13:25 -0500
Message-ID: <1387480400.1876.32.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH] drivers: ptp: Include new header file in ptp_pch.c
From: Ben Hutchings <bhutchings@solarflare.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: David Miller <davem@davemloft.net>, <rashika.kheria@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dvhart@linux.intel.com>,
        <joe@perches.com>, <andriy.shevchenko@linux.intel.com>,
        <vfalico@redhat.com>, <netdev@vger.kernel.org>,
        <josh@joshtriplett.org>
Date: Thu, 19 Dec 2013 19:13:20 +0000
In-Reply-To: <20131219072757.GB4281@netboy>
References: <1387140255-11797-1-git-send-email-rashika.kheria@gmail.com>
	 <20131216085839.GA8303@netboy>
	 <20131218.174359.2230195267384857675.davem@davemloft.net>
	 <20131219072757.GB4281@netboy>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20370.002
X-TM-AS-Result: No--23.115500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 08:27 +0100, Richard Cochran wrote:
> On Wed, Dec 18, 2013 at 05:43:59PM -0500, David Miller wrote:
> > 
> > I think this begs an even more fundamental question, why isn't the PTP
> > driver abstraction providing the necessary methods and interfaces so
> > that pch_gbe doesn't have to call into the ptp_pch.c code directly?
> 
> Really it is more of a driver issue. For MAC based PTP clocks, they
> are so tightly coupled to the MAC driver that it is better *not* to
> have the PTP functions in a separate module. Instead, if having the
> PTP stuff optional makes sense, then the PTP parts are just a compile
> time option in the MAC driver. This is how the other MAC drivers with
> optional PTP are structured.
[...]

PTP is no longer a compile-time option in most net drivers.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

