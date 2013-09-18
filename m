Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3IRKfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:35:33 -0400
Received: from helium.waldemar-brodkorb.de ([89.238.66.15]:45739 "EHLO
	helium.waldemar-brodkorb.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464Ab3IRKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:35:32 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 06:35:31 EDT
Date: Wed, 18 Sep 2013 12:27:01 +0200
From: Waldemar Brodkorb <wbx@openadk.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: problem booting linux with qemu-system-arm -M spitz
Message-ID: <20130918102701.GJ14246@waldemar-brodkorb.de>
Reply-To: Waldemar Brodkorb <wbx@openadk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: Linux 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kernel hackers,

I am trying to run Linux on Qemu/arm emulator with machine type
spitz. In the past this worked fine.
Now with Linux version 3.9.11 it does not boot anymore. 
(blank screen, no kernel messages)

I used git bisect to find the commit, which breaks the boot:
commit 4e8ee7de227e3ab9a72040b448ad728c5428a042
Author: Will Deacon <will.deacon@arm.com>
Date:   Wed Nov 23 12:26:25 2011 +0000

I am using Qemu 1.6.0 on a Debian/x86_64 host.

Any help would be appreciated.

Thanks in advance
 Waldemar
