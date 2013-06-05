Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3FEOvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:51:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59873 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756427Ab3FEOvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:51:39 -0400
Date: Wed, 5 Jun 2013 10:51:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <sarah.a.sharp@intel.com>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [RFC PATCH v3 0/4] Add usb2 link powermanagement BESL support
In-Reply-To: <20130604230534.GB6289@xanatos>
Message-ID: <Pine.LNX.4.44L0.1306051051130.1078-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Sarah Sharp wrote:

> Alan, Greg, any more comments on this patchset?
> 
> It looks fine to me, and we've been testing it internally within Intel,
> so I'll queue it up for 3.11 if you don't have any more objections.

No objections to any of the parts touching the USB core.

Alan Stern

