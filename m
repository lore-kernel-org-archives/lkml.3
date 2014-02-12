Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaBLQkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:40:05 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:53144 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931AbaBLQkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:40:03 -0500
Date: Wed, 12 Feb 2014 16:39:38 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Madper Xie <cxie@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at
 ffffffffff340003
Message-ID: <20140212163938.GA20717@console-pimps.org>
References: <8738jr5t3e.fsf@redhat.com>
 <20140210175246.GB2887@console-pimps.org>
 <87mwhy8iaj.fsf@redhat.com>
 <20140211131640.GD2887@console-pimps.org>
 <87lhxh69u0.fsf@redhat.com>
 <20140211141846.GA1725@console-pimps.org>
 <1392221703.5612.164.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392221703.5612.164.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb, at 09:15:03AM, Toshi Kani wrote:
> 
> Yes, I agree that the table size should be 0x38.  However, ACPI spec
> states that bit0 of status indicates if the boot image graphic is valid.
> This bit is set to 0 (invalid) on the system.  Can you check this bit
> and return when invalid? 

Seems reasonable to me. Anyone know of a reason that wouldn't work?

-- 
Matt Fleming, Intel Open Source Technology Center
