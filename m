Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaGaW3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:29:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaGaW3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:29:51 -0400
Date: Thu, 31 Jul 2014 15:29:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Tenoutit, Faouaz" <faouaz.tenoutit@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 V2] USB: Use ACPI device information
Message-ID: <20140731222923.GB9025@kroah.com>
References: <56D4B9BFEADA5948B14547D2A81CE2C0284660F3@HASMSX106.ger.corp.intel.com>
 <140713857.5QYWLe1hHM@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <140713857.5QYWLe1hHM@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 12:37:49AM +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 09, 2014 04:42:38 PM Tenoutit, Faouaz wrote:
> > From: Faouaz TENOUTIT <faouaz.tenoutit@intel.com>
> > 
> > Use ACPI device pld information instead of calling
> > acpi_get_physical_device_location.
> > 
> > Signed-off-by: Faouaz TENOUTIT <faouaz.tenoutit@intel.com>
> > Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
> 
> Greg, Alan, any objections agains this?

Deleting USB acpi code?  Never an objection from me :)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

