Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbbAUSb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:31:27 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbAUSbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:31:20 -0500
Date: Wed, 21 Jan 2015 10:31:18 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Oliver Neukum <oneukum@suse.de>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 0/4] toshiba_acpi: Add support for USB Sleep functions
Message-ID: <20150121183118.GD7386@vmdeb7>
References: <1421631025-27895-1-git-send-email-coproscefalo@gmail.com>
 <1421752526.29486.18.camel@linux-0dmf.site>
 <CAGdLNWGJwXTS1GBkWeOZKfeACZhociMqSVrz-=7XFQTTxEf+TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdLNWGJwXTS1GBkWeOZKfeACZhociMqSVrz-=7XFQTTxEf+TA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 11:21:06AM -0700, Azael Avalos wrote:
> Hi there,
> 
> Sorry for the late reply.
> 
> 2015-01-20 4:15 GMT-07:00 Oliver Neukum <oneukum@suse.de>:
> > On Sun, 2015-01-18 at 18:30 -0700, Azael Avalos wrote:
> >> The following patches add support to several USB Sleep functions
> >> found on newer Toshiba laptops, allowing to use the USB ports while
> >> the laptop is asleep or turned off.
> >
> > Hi,
> >
> > this is most interesting. But the interface is terrible. If
> 
> Well, I'm just providing the on/off switch on Toshiba specific hardware,
> but I'm unaware/unfamiliar with how other vendors implement this
> feature.
> 
> > possible we would like to have a generic interface for this,
> > which should not depend on the specific platform in use and would
> > have to be per bus or even per port (for example the ports on a
> > Thunderbolt dock would not work with your module).
> 
> Sounds good, as not all ports carry such functionality, on my
> current laptop only two ports provide this, the other two are just
> normal USB 2/3 ports (configurable ;-) ).
> 
> > Do you think we could provide a hook from generic code into
> > platform code to detect the capability for power control?
> 
> If there's an existing API already, I'll be glad to modify the code to
> use it, if it doesn't exist yet, I'll simply adapt the code to the chosen
> standard whenever becomes available.

Given the ACPI calls which are platform specific, a general purpose driver
doesn't seem likely. I'm keeping this queued as is unless you ask me to drop it
Azael.

-- 
Darren Hart
Intel Open Source Technology Center
