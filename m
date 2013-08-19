Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3HSXfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:35:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42613 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3HSXfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:35:38 -0400
Date: Mon, 19 Aug 2013 16:35:29 -0700
From: Jerry Snitselaar <jerry.snitselaar@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] acpi_i2c: set MODULE_LICENSE, MODULE_AUTHOR, and
 MODULE_DESCRIPTION
Message-ID: <20130819233528.GA4587@cantor.us.oracle.com>
Reply-To: Jerry Snitselaar <jerry.snitselaar@oracle.com>
References: <1376702795-25912-1-git-send-email-jerry.snitselaar@oracle.com>
 <20130819061614.GG4898@intel.com>
 <2870377.GVGv4QBgQK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2870377.GVGv4QBgQK@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Aug 20 13, Rafael J. Wysocki wrote:
> On Monday, August 19, 2013 09:16:14 AM Mika Westerberg wrote:
> > On Fri, Aug 16, 2013 at 06:26:35PM -0700, Jerry Snitselaar wrote:
> > > Without MODULE_LICENSE set, I get the following with modprobe:
> > > 
> > > acpi_i2c: module license 'unspecified' taints kernel.
> > > acpi_i2c: Unknown symbol i2c_new_device (err 0)
> > > acpi_i2c: Unknown symbol acpi_dev_get_resources (err 0)
> > > acpi_i2c: Unknown symbol acpi_dev_resource_interrupt (err 0)
> > > acpi_i2c: Unknown symbol acpi_dev_free_resource_list (err 0)
> > > 
> > > Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
> > 
> > Looks good to me.
> > 
> > Acked-by: Mika Westerbeg <mika.westerberg@linux.intel.com>
> 
> Well, OK, but do we need to be able to build that as a module?
> 
> Maybe it should just be yes or no?
> 
> Rafael
> 

Perhaps have depends on I2C=y and be a bool instead of tristate?
