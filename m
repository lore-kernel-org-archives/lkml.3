Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaCVQwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:52:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaCVQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:52:46 -0400
Date: Sat, 22 Mar 2014 09:54:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3.13 072/149] ACPI / resources: ignore invalid ACPI
 device resources
Message-ID: <20140322165415.GA18780@kroah.com>
References: <20140321000436.377902063@linuxfoundation.org>
 <20140321000439.452672105@linuxfoundation.org>
 <201403220230.49584.s.L-H@gmx.de>
 <20140322162638.GE13385@kroah.com>
 <1395506158.2159.2.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395506158.2159.2.camel@x220>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 05:35:58PM +0100, Paul Bolle wrote:
> On Sat, 2014-03-22 at 09:26 -0700, Greg Kroah-Hartman wrote:
> > Is this also a problem in Linus's tree?  If so, shouldn't a fix go there
> > first?
> 
> That fix is commit 89935315f192 ("PNP / ACPI: proper handling of ACPI
> IO/Memory resource parsing failures"), included in v3.14-rc7.

Ah, many thanks, now queued up.

greg k-h
