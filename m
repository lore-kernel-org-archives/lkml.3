Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3AXAeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:34:20 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58427 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3AXAeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:34:10 -0500
Date: Wed, 23 Jan 2013 16:34:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH 5/5] ACPI / PM: Expose lists of device power
 resources to user space
Message-ID: <20130124003407.GC10969@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <2760421.6nE3tkh92K@vostro.rjw.lan>
 <1551140.kO91IOVbjI@vostro.rjw.lan>
 <2472424.tpzyPyItMj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2472424.tpzyPyItMj@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 07:01:37PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since ACPI power resources are going to be used more extensively on
> new hardware platforms, it is necessary to allow user space (powertop
> in particular) to look at the lists of power resources corresponding
> to different power states of devices for diagnostics and control
> purposes.
> 
> For this reason, for each power state of an ACPI device node using
> power resources create a special attribute group under the device
> node's directory in sysfs containing links to sysfs directories
> representing the power resources in that list.  The names of the
> new attribute groups are "power_resources_<state>", where <state>
> is the state name i.e. "D0", "D1", "D2", or "D3hot".
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks for fixing this up.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
