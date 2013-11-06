Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3KFObK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:31:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34365 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab3KFObI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:31:08 -0500
Date: Wed, 6 Nov 2013 14:30:59 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: new asus fan driver
Message-ID: <20131106143059.GA24451@srcf.ucam.org>
References: <1383641987-4403-1-git-send-email-felipe.contreras@gmail.com>
 <20131105125228.GB18093@kroah.com>
 <CAMP44s0i-xCNHW_PPyO57p9yt0X_9OaYSQDkVPoNKum=nEHQbw@mail.gmail.com>
 <20131105151609.GA20950@kroah.com>
 <CAMP44s2BmZY2vQXQKsWmF68td8w9i4YNzp-o37ZN3YzsyZ3SWA@mail.gmail.com>
 <20131106021933.GA7242@kroah.com>
 <CAMP44s2vHKuNyqRndWty+-Ua47KEL8fwfeq+sakC7MJKv5KrTw@mail.gmail.com>
 <20131106085556.GA9487@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106085556.GA9487@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 12:55:56AM -0800, Greg Kroah-Hartman wrote:

> Matthew, please don't push drivers to the staging tree that have no
> problems on their own, and don't require work within them to get out of
> staging, as that doesn't help much, as I don't want to take code that
> has to wait for external things to happen before it can move out of
> staging.

I'm not willing to commit to supporting this code with the 
virt_to_phys() hack in place, but I also don't want to block Felipe from 
having an incentive to fix up the ACPI core so we can do this cleanly. 
What I suggested was adding it to the asus-wmi driver and wrapping the 
functionality with CONFIG_STAGING in order to indicate that there were 
no promises that this feature would remain, and then giving Felipe a few 
months to do the ACPI work. If it got done in a reasonable time then 
we'd keep the code, and if not I'd drop it. I certainly didn't suggest 
writing a separate driver, let alone putting it in staging.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
