Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3GCSdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:33:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab3GCSdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:33:13 -0400
Date: Wed, 3 Jul 2013 11:33:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/8] Thunderbolt workarounds
Message-ID: <20130703183311.GA17340@kroah.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130703182900.GA29079@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703182900.GA29079@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 07:29:00PM +0100, Matthew Garrett wrote:
> Are there any plans to provide native support for the Thunderbolt 
> controller, rather than relying on system management mode?

For what specific hardware platform?  For the ones that this patchset
controls, the OS doesn't have access to the Thunderbolt controller as
far as I can tell, it all happens through the ACPI and PCI hotplug
interface.

thanks,

greg k-h
