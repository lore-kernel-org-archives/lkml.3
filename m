Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924Ab3EHEJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 00:09:12 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:56856 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3EHEJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 00:09:05 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 21:09:04 -0700
Message-ID: <CACtbSuSDBe33DGfR0LFXCtzRYBaF-JuKBjYWu8QFEdw7nENPSA@mail.gmail.com>
Subject: [PATCH] [SVN] Please Merge 7 VirtualBox Kernel Modules into the Linux Kernel
From: quickbooks office <quickbooks.office@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, vbox-dev@virtualbox.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Merge VirtualBox Kernel Modules into the Kernel.

-----------------------------------------------------------------------------------------------------------

svn co http://www.virtualbox.org/svn/vbox/trunk vbox
sh '/home/user/vbox/src/VBox/Additions/linux/export_modules'
VBoxGuestModules.tar.gz

Extracting VBoxGuestModules.tar.gz will give the Source Code for 3
modules (used in a Linux Guest):

1. vboxguest (VirtualBox guest kernel module)

2. vboxsf (VirtualBox guest kernel module for shared folders)

3. vboxvideo (VirtualBox guest kernel module for drm support)

-----------------------------------------------------------------------------------------------------------

sh '/home/user/vbox/src/VBox/HostDrivers/linux/export_modules'
VBoxHostModules.tar.gz

Extracting VBoxHostModules.tar.gz will give the Source Code for 4
modules (used in a Linux Host):

1. vboxdrv (VirtualBox host kernel module)

2. vboxnetflt (VirtualBox netfilter kernel module)

3. vboxnetadp (VirtualBox network adapter kernel module)

4. vboxpci (VirtualBox host PCI access kernel module)


-----------------------------------------------------------------------------------------------------------


Maintaner contacts:

1. vbox-dev Mailing List:
https://www.virtualbox.org/mailman/listinfo/vbox-dev  (Probably
Requires you to join the mailing list in order to post) -
vbox-dev@virtualbox.org

or

2. Public bugtracker: https://www.virtualbox.org/wiki/Bugtracker
(Requires an Oracle account for sign on)
