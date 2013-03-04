Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3CDD5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:57:03 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:54094 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab3CDDoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:16 -0500
Date: Mon, 4 Mar 2013 11:44:30 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ley Foon Tan <lftan@altera.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/misc: Add Altera System ID driver
Message-ID: <20130304034430.GA1274@kroah.com>
References: <1362366697-2768-1-git-send-email-lftan@altera.com>
 <201303040332.20076.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303040332.20076.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 03:32:19AM +0000, Arnd Bergmann wrote:
> On Monday 04 March 2013, Ley Foon Tan wrote:
> > This patch is to add Altera System ID driver.
> > User can obtain the system ID and timestamp of the system by
> > reading the sysfs entry.
> > 
> > Usage:
> > cat /sys/bus/platform/devices/[addr].sysid/sysid/id
> > cat /sys/bus/platform/devices/[addr].sysid/sysid/timestamp
> > 
> > Signed-off-by: Ley Foon Tan <lftan@altera.com>
> 
> All sysfs files need documentation in Documentation/ABI/.
> 
> This driver looks like it should instead be using the infrastructure we
> have for identifying an SoC in drivers/base/soc.c, which is currently
> only used by the ARM u8500 platform but was introduced as a generic
> interface for this a while ago.

I agree, this shouldn't be a one-off sysfs file.

greg k-h
