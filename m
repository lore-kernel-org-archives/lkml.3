Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3DWSdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:33:07 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:63295 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab3DWSdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAMix8LGzh1Sr-s=m4eQcRMYSDTuC=g2ddDwPbGcRvrnU3EYP5Q@mail.gmail.com>
References: <CAMix8LGzh1Sr-s=m4eQcRMYSDTuC=g2ddDwPbGcRvrnU3EYP5Q@mail.gmail.com>
Date: Tue, 23 Apr 2013 20:33:04 +0200
Message-ID: <CAMix8LHNNFpz42BONnXu86Mvxx-h3FWb9_AOqGLS1NE8LSGt3g@mail.gmail.com>
Subject: Fwd: ehci-pci failed handover
From: =?UTF-8?Q?Jes=C3=BAs_J=2E_Guerrero_Botella?= 
	<jesus.guerrero.botella@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I am getting some strange messages when I try to connect a Logitech
m185 wireless mouse to my Pavilion zd8000.

The mouse works in some other machines, and the usb ports of the
pavillion have been tested only with regular pendrives, which work
fine, but nothing else.

When I attach the mouse I get messages like these:

===
 usb usb1: usb wakeup-resume
 usb usb1: usb auto-resume
 ehci-pci 0000:00:1d.7: resume root hub
 ehci-pci 0000:00:1d.7: GetStatus port:8 status 001000 0  ACK POWER sig=se0
 ehci-pci 0000:00:1d.7: failed handover port 8: 1000
 hub 1-0:1.0: hub_resume
 ehci-pci 0000:00:1d.7: GetStatus port:5 status 001803 0  ACK POWER
sig=j CSC CONNECT
 hub 1-0:1.0: port 5: status 0501 change 0001
 hub 1-0:1.0: state 7 ports 8 chg 0020 evt 0000
 hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
 ehci-pci 0000:00:1d.7: port 5 full speed --> companion
 ehci-pci 0000:00:1d.7: GetStatus port:5 status 003801 0  ACK POWER
OWNER sig=j CONNECT
 hub 1-0:1.0: port 5 not reset yet, waiting 50ms
 ehci-pci 0000:00:1d.7: GetStatus port:5 status 003002 0  ACK POWER
OWNER sig=se0 CSC
 hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0020
 ehci-pci 0000:00:1d.7: GetStatus port:5 status 003002 0  ACK POWER
OWNER sig=se0 CSC
 hub 1-0:1.0: port 5, status 0100, change 0001, 12 Mb/s
 hub 1-0:1.0: debounce: port 5: total 100ms stable 100ms status 0x100
 hub 1-0:1.0: hub_suspend
 usb usb1: bus auto-suspend, wakeup 1
 ehci-pci 0000:00:1d.7: suspend root hub
===

HID stuff is enabled in my kernel, but for what I read in that output
I don't think it's even reaching that stage, is it?

This is gentoo, using linux 3.8.7, I can attach the .config if needed.
Don't want to spam the list. I have used this same mouse in my desktop
(gentoo as well) and it's working nicely.

Can you give me some pointers on how to proceed?

Thanks beforehand for any help, or just for reading :)

--
Jesús Guerrero Botella
