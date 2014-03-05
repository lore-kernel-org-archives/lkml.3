Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaCEOWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:22:25 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:48861 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbaCEOWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:22:24 -0500
MIME-Version: 1.0
Date: Wed, 5 Mar 2014 19:52:23 +0530
Message-ID: <CAOAoqGuicMKJ8e6kmQ92fL73UpvBzfXx9kafP4tCbUKkiT2=vA@mail.gmail.com>
Subject: USB remote wakeup through gpio interrupt
From: Jagdish Gedia <jvgediya@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
There is some inconsistency in remote wakeup functionality in my
custom board. so I want to wakeup the runtime suspended USB host
through interrupt. My USB device is connected to the board through USB
interface and some gpios. device will give interrupt on processor gpio
when it needs attention of USB host. What should i do so that i can
wakeup the usb host when i get interrupt from the device.

My idea was to apply power management related hooks from the interrupt
handler, but I am not getting the clear idea.

My main doubt is,
Will this mechanism be efficient as remote wakeup functionality?
