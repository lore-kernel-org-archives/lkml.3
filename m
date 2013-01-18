Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3ARTyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:54:04 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47121 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3ARTyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:54:02 -0500
Date: Fri, 18 Jan 2013 11:53:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.8-rc4
Message-ID: <20130118195358.GA19035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8cf65dc386f3634a43312f436cc7a935476a40c4:

  usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added (2013-01-13 13:44:23 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.8-rc4

for you to fetch changes up to 1ee0a224bc9aad1de496c795f96bc6ba2c394811:

  USB: io_ti: Fix NULL dereference in chase_port() (2013-01-17 17:34:39 -0800)

----------------------------------------------------------------
USB fixes for 3.8-rc4

Here are 3 USB patches for 3.8-rc4.  Two of them are new device id
patches, and the third fixes a reported oops in the io_ti USB serial
driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Bjørn Mork (2):
      USB: option: blacklist network interface on ONDA MT8205 4G LTE
      USB: option: add TP-LINK HSUPA Modem MA180

Wolfgang Frisch (1):
      USB: io_ti: Fix NULL dereference in chase_port()

 drivers/usb/serial/io_ti.c  | 3 +++
 drivers/usb/serial/option.c | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)
