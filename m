Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3ATXhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:37:41 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36984 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3ATXhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:37:39 -0500
Date: Sun, 20 Jan 2013 15:37:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH 0/3] ACPI / PM: Export power resources information
 to user space
Message-ID: <20130120233735.GA7449@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3307415.pdOY6ovZLa@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 03:51:40PM +0100, Rafael J. Wysocki wrote:
> Hi Greg,
> 
> The following patch series is about exporting ACPI power resources to user
> space that will be necessary for PM diagnostics on new platforms (powertop is
> the target).  Still, existing systems can also benefit from that, like my
> oldish HP nx6325 on which the patches have been tested.
> 
> Patch [1/3] shouldn't be really controverisal, as it only makes it possible
> to read power resources' reference counters from user space in a quite
> straightforward way.

You need to add a Documentation/ABI/ entry for the new file you created
here.  Same thing for 3/3, which will help me understand exactly what
you are trying to do here with sysfs.  Care to update that so I can try
to figure out if the sysfs code is correct?

thanks,

greg k-h
