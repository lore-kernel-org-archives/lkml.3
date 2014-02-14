Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaBNWFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:05:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaBNWFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:05:11 -0500
Date: Fri, 14 Feb 2014 14:06:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Josh Cartwright <joshc@codeaurora.org>, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / platform: drop redundant ACPI_HANDLE check
Message-ID: <20140214220630.GA7046@kroah.com>
References: <1392350443-20074-1-git-send-email-joshc@codeaurora.org>
 <1746200.FR6bSit96i@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1746200.FR6bSit96i@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 02:45:29PM +0100, Rafael J. Wysocki wrote:
> On Thursday, February 13, 2014 10:00:43 PM Josh Cartwright wrote:
> > The acpi_dev_pm_attach/_detach functions perform their own checks to
> > ensure the device has an ACPI companion.  It is not necessary for the
> > caller to do so.
> > 
> > This mirrors what other busses with ACPI dev PM support do (i2c, spi,
> > sdio).
> > 
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> 
> Hi Greg,
> 
> If you want to take this, please feel free to add:
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> to it.  If you want me to take it, please let me know.

Thanks, I'll go take it through my tree.

greg k-h
