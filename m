Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3FFXk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 19:40:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3FFXk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 19:40:58 -0400
Date: Thu, 6 Jun 2013 16:40:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 007 release
Message-ID: <20130606234057.GA14840@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 007 release of usbutils.

Nothing major over the 006 release, just a bunch of tiny bug fixes that
have trickled in over the past year.  The short changelog can be found
below.

The package can be downladed from kernel.org:
        http://www.kernel.org/pub/linux/utils/usb/usbutils/

The source tree for usbutils can be found on both kernel.org and
github.com if you want to fork it and send us changes easier:
	http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
	http://github.com/gregkh/usbutils/tree/master

thanks,

greg k-h

-----------

Aurelien Jarno (1):
      usb-devices: correctly quote driver path

Bjørn Mork (4):
      lsusb: decode CDC MBIM descriptor
      lsusb: decode CDC NCM functional descriptor
      lsusb: decode CDC Command Set descriptor
      usb-devices: avoid numbers being seen as octal by printf

Daniel Mack (1):
      lsusb: parse bmFormats inside UAC2 interface headers as hex

Greg Kroah-Hartman (12):
      do_release notes
      Merge pull request #11 from bmork/mbim
      update of usb.ids file from upstream
      Merge pull request #13 from bmork/for-greg
      remove devtree logic
      Merge pull request #14 from SpecLad/master
      Merge pull request #16 from zonque/uac2
      Merge pull request #15 from lnykryn/master
      Merge pull request #17 from hegge/uac1-misplaced-endpoint
      Merge pull request #18 from jethrogb/master
      usb.ids update
      usb.ids add BlueZ Host stack device id.

Jethro Beekman (1):
      Fix lsusb -t potentially not listing all devices

Lukas Nykryn (1):
      lsusb-t: make sure that interfaces are added to lists only once

Sarah Sharp (2):
      lsusb: Fix USB 3.0 link state reporting.
      lsusb: Fix bug in USB 2.0 extended caps descriptor.

Torstein Hegge (1):
      lsusb: Parse misplaced UAC1 AudioControl Endpoint Descriptor

Роман Донченко (1):
      lsusb: Support non-ASCII string descriptors.

