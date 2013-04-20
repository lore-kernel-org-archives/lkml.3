Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3DTKKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 06:10:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51255 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3DTKKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 06:10:39 -0400
MIME-Version: 1.0
Date: Sat, 20 Apr 2013 10:10:37 +0000
Message-ID: <CAEJHKkUfAUTRnRHXoniYVtxmWC=wx+YH+LJQjRs=q-Vugb2dow@mail.gmail.com>
Subject: usb serial trouble 2.6.38
From: basteon <basteon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
Here anyone use linux kernel 2.6.38, this version still supported?
This not in longterm kernel list, anyway.
I've try to use usb stack and it works only if hid and usb does in kernel.
What if I make it in modules
usbcore,ehci_hcd,uhci_hcd,usb_storage,ipaq,usbserial. There only
storage will work, it's not working if usbcore inside the kernel.

Also usbhid(i.e usb keyboard) doesn't work.
It does if all linked inside kernel.
why such things could be happening?
I compile kernel with one configuration x86_64, just change those
modules parameters, no tracers included.
