Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaICVIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:08:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52399 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbaICVIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:08:23 -0400
Date: Wed, 3 Sep 2014 14:08:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 00/56] 3.12.28-stable review
Message-ID: <20140903210812.GA22289@roeck-us.net>
References: <cover.1409735865.git.jslaby@suse.cz>
 <5407170F.2070701@roeck-us.net>
 <54076CB2.6040004@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54076CB2.6040004@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 09:32:02PM +0200, Jiri Slaby wrote:
> On 09/03/2014, 03:26 PM, Guenter Roeck wrote:
> > On 09/03/2014 02:26 AM, Jiri Slaby wrote:
> >> This is the start of the stable review cycle for the 3.12.28 release.
> >> There are 56 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Fri Sep  5 11:17:45 CEST 2014.
> >> Anything received after that time might be too late.
> >>
> > 
> > Jiri,
> > 
> > I get a large number of build failures.
> ...
> > In file included from drivers/usb/host/ohci-hcd.c:85:0:
> > drivers/usb/host/ohci-dbg.c:411:20: error: conflicting types for
> > 'ohci_dump'
> > drivers/usb/host/ohci-hcd.c:81:13: note: previous declaration of
> > 'ohci_dump' was here
> > drivers/usb/host/ohci-hcd.c: In function 'ohci_run':
> > drivers/usb/host/ohci-hcd.c:757:2: error: too few arguments to function
> > 'ohci_dump'
> 
> Oh, !USB_DEBUG. It should be fixed, could you retry?
> 
Much better.

Build results:
	total: 135 pass: 135 fail: 0

Qemu tests all passed.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
