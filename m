Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaANTcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:32:19 -0500
Received: from fep20.mx.upcmail.net ([62.179.121.40]:59907 "EHLO
	fep20.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaANTcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:32:18 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jan 2014 14:32:17 EST
X-SourceIP: 37.49.105.23
X-Authenticated-Sender: bjoern.christoph@kabelbw.de
Date: Tue, 14 Jan 2014 20:32:10 +0100
From: bjoern <lkml@call-home.ch>
To: linux-kernel@vger.kernel.org
Subject: Kernel above 3.8 prevents booting Linux
Message-ID: <20140114203210.76eeed0d@ubuntu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.13; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an Ubuntu 12.04 x64 server. The hard disk is encrypted using LVM.

With kernel 3.8.8, the server works fine - I am asked to enter the
password and can boot the system.

Any kernel above 3.8, e.g. 3.9/3.11 (I didn't try many) prevents me from
entering the password. It seems the attached USB keyboard is no longer
being read from or the system is hanging.

I can however switch between the kernels in GRUB - it's only after the
kernel has been selected and the password screen is displayed that the
system hangs.

I'd like to help in nailing down the bug but I'm at a loss what to do
here as I can't get to any console or kernel logs.

Regards,
Bjoern
