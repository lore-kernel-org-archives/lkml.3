Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaKXJRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:17:49 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:43388 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKXJRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:17:47 -0500
Date: Mon, 24 Nov 2014 09:17:29 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Jamet, Michael" <michael.jamet@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Levy, Amir (Jer)" <amir.jer.levy@intel.com>,
        "Alloun, Dan" <dan.alloun@intel.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O
 resources.
Message-ID: <20141124091729.3de7ae7b@lxorguk.ukuu.org.uk>
In-Reply-To: <CAErSpo5z41ZOL3xUwwSZ8UE_KGmCDOUmFQ3CY_QwF7JVhU1-EQ@mail.gmail.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
	<CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com>
	<BC567D27D6B7384F84318942321624DE16179E60@hasmsx109.ger.corp.intel.com>
	<CAErSpo5z41ZOL3xUwwSZ8UE_KGmCDOUmFQ3CY_QwF7JVhU1-EQ@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This was also discussed internally and the only way to identify Thunderbolt devices is to check the device IDs.
> > As you said, this will require us to maintain and keep the list up-to-date as we deliver new devices.
> 
> I don't really see how this can work.  You're asking me to put changes
> based on a secret spec into generic code that is used on every machine
> with PCI.  I have no way to maintain something like that.

> 
> This seems like a major screw up in the design and documentation of Thunderbolt.

See
https://developer.apple.com/library/mac/documentation/HardwareDrivers/Conceptual/ThunderboltDevGuide/ThunderboltDevGuide.pdf

page 10 for one of the brief public notes on the not relying on I/O space.

