Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbaGROp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:45:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54811 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761477AbaGROp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:45:27 -0400
Date: Fri, 18 Jul 2014 10:45:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nick Krause <xerofoify@gmail.com>
cc: Greg KH <gregkh@linuxfoundation.org>, <mail@beyermatthias.de>,
        <hdegoede@redhat.com>, <sarah.a.sharp@linux.intel.com>,
        <dan.j.williams@intel.com>, <valentine.barshak@cogentembedded.com>,
        <ming.lei@canonical.com>, <michael.opdenacker@free-electrons.com>,
        <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: hcd.c Fix me statements
In-Reply-To: <CAPDOMVhu1Pd8qGcPBRJ0HUAb+S2x3hqcTBXfy1-XG_4aW1otXw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1407181042300.979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Nick Krause wrote:

> I am assuming this is a stupid question but since I am new I will ask it anyway.
> Can the  usb_bus  structure be Null? If can I will send it a patch removing the
> fix mes on  lines 854 and 878 of hcd.c .

Line numbers in a source file usually aren't very useful.  They're 
different in every version of the kernel.  Instead just mention which 
functions you're talking about.  It looks like 
authorized_default_show() and authorized_default_store().

Yes, it's true that usb_bus (which is a pointer, not a structure) can
never be NULL.

Alan Stern

