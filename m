Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3AXAdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:33:51 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51638 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3AXAdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:33:47 -0500
Date: Wed, 23 Jan 2013 16:33:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH 4/5] sysfs: Functions for adding/removing
 symlinks to/from attribute groups
Message-ID: <20130124003343.GB10969@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <2760421.6nE3tkh92K@vostro.rjw.lan>
 <1551140.kO91IOVbjI@vostro.rjw.lan>
 <1511541.AH8DLsNQJH@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511541.AH8DLsNQJH@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 07:00:54PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The most convenient way to expose ACPI power resources lists of a
> device is to put symbolic links to sysfs directories representing
> those resources into special attribute groups in the device's sysfs
> directory.  For this purpose, it is necessary to be able to add
> symbolic links to attribute groups.
> 
> For this reason, add sysfs helper functions for adding/removing
> symbolic links to/from attribute groups, sysfs_add_link_to_group()
> and sysfs_remove_link_from_group(), respectively.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

