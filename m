Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934614AbaFSVKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:10:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47908 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934385AbaFSVKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:10:05 -0400
X-Sasl-enc: qEYmMRw7s6nMfvuKawUu8nInz//L2ZSG3Tv/vJESsis/ 1403212203
Date: Thu, 19 Jun 2014 14:14:03 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 00/15] Thunderbolt driver for Apple MacBooks
Message-ID: <20140619211403.GA3589@kroah.com>
References: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 10:03:57PM +0200, Andreas Noever wrote:
> Hi,
> 
> Updated version of the driver. Includes changes by Matthew to make it work on
> Falcon Ridge hardware (present in the newest Mac(Book)Pro). 
> 
> Changes since v4 (suggested by Matthew):
>  - Changed the PCI quirks to check just for Apple hardware instead of checking
>    against a list of machines. (The PCI id check already restricts this quirk
> to the relevant Apple machines).
>  - Added Falcon Ridge PCI id to the driver and to the "wait_for_thunderbolt"
>    quirk (the "poweroff_thunderbolt" quirk is no longer necessary for Falcon
> Ridge devices).
>  - Fixed plug events for Falcon Ridge hardware.

Very nice work, I've now queued this up for 3.17 merge.

> @Matthew: I think that your patch was missing the Falcon Ridge PCI id within
> the wait_for_thunderbolt quirk (I have added it). If you have time could you
> verify that suspend/resume works on your MacPro?  Thanks!
> 
> As before Matthew's ACPI changes (latest version: [1]) are required for this to
> work properly. Without them you need to boot with a coldplugged TB device to
> prevent the firmware from disabling the controller.

What is the status of these patches making it in for 3.17?

thanks,

greg k-h
