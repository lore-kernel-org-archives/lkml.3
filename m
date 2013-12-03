Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3LCRer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:34:47 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:35647 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3LCReq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:34:46 -0500
MIME-Version: 1.0
Reply-To: pricardofc@ipfn.ist.utl.pt
Date: Tue, 3 Dec 2013 17:34:44 +0000
X-Google-Sender-Auth: tagdU8jGcfwrZKoL7wzs6AfyhHc
Message-ID: <CAH9N0t8VV4A+hJj89K7bewV5JLE4=KS2cAsc+CyeKQ-9x4U_mQ@mail.gmail.com>
Subject: PCIExpress ATCA card Hotplug device driver
From: Paulo Fortuna Carvalho <pricardofc@ipfn.ist.utl.pt>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
 I have an ATCA card system and Linux PCI device drivers for the card.
 I need to implement automatic hotplug card insertion/removal
 capabilities in the system.
 My Linux is redhat 6 with kernel 3.0.9-rt26.46.el6rt.x86_64
 I have pciehp.ko module loaded at system boot and my PCIe card device
 driver follows the Linux device driver model.

 I have 2 questions:
 1) Does my Linux device driver needs to be changed to a service port
 driver? (if so how?)
 2) Do I need to use udev mechanism to handle hotplug along pciehp.ko
 module? (if so how?).

Can anyone give me a hand?
Thx in advance,
Ricardo-Fortuna
