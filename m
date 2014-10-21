Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbaJUVUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:20:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170AbaJUVUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:20:06 -0400
Date: Wed, 22 Oct 2014 05:18:55 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 008 release
Message-ID: <20141021211855.GA27097@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 008 release of usbutils.

It's been over a year since the 007 release, and a bunch of small
bugfixes have piled up, along with a much larger change of now using the
hwdb instead of the old usb.ids file (a patch which almost all distros
using systemd have been shipping for a while), so it's time for a new
release.

The short changelog can be found below.

The package can be downladed from kernel.org:
        http://www.kernel.org/pub/linux/utils/usb/usbutils/

The source tree for usbutils can be found on both kernel.org and
github.com if you want to fork it and send us changes easier:
	http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
	http://github.com/gregkh/usbutils/tree/master

thanks,

greg k-h

-----------

Alexandra Yates (2):
      lsusb: Reports if USB2.0 port is on L1 state
      lsusb: Reports devices that support BESL on USB2.0

Aurelien Jarno (1):
      dump_ccid_device: fix a typo

Ben Chan (1):
      lsusb: decode CDC MBIM extended functional descriptor

Greg Kroah-Hartman (10):
      lsusb: fix incorrect printf() for CAPS
      lsusb-t: handle problem if there is no usb bus list
      .gitignore: add compile to the list of things we need to ignore
      usbutils 008 release

John Freed (1):
      Fix logic error

Kurt Garloff (1):
      Update lsusb.py in usbutils

Lukas Nykryn (2):
      update COPYING file
      lsusb-t: don't segfault when usbbuslist is empty

Peter Wu (1):
      Ignore invalid string descriptors

Raphaël Droz (1):
      usb-devices: hexadecimal bInterfaceNumber handling

Tom Gundersen (2):
      lsusb: port to hwdb
      drop dependency on usb.ids

Vadim Rutkovsky (1):
      New path for usbhid-dump submodule

