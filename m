Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3FOFOM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 01:14:12 -0400
Received: from fireacop.com ([50.97.39.154]:34696 "HELO fireacop.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751986Ab3FOFOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 01:14:11 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Jun 2013 01:14:11 EDT
Date: Sat, 15 Jun 2013 00:07:29 -0500
From: kernel-dev@fireacop.com
To: linux-kernel@vger.kernel.org
Subject: Gumstix Overo Linux 3.10-rc5 overo-defconfig etc.
Message-ID: <20130615050729.GA20217@fireacop.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been using linux on Gumstix since around 2007.

I recently posted a request to help me bring an OEM
driver from 2.6.29 to 2.6.34, since that is the kernel
of the system I am developing user-space code on.

I have gotten 3.x kernels working on Gumstix 
in the past, but at some point forgot about the change 
from ttyS2 to ttyO2, and so gave up on that to finish my code.

Since I was informed that I need to make requests for assistance 
against current kernels, I recently built and booted 3.9.5, 3.9.6,
and 3.10-rc5 on a Gumstix Overo, on a Gallop-43 Breakout Board. 

I started with a 3.5 kernel that Gumstix publishes that
was built by the Yocto Project, extracted the .config,
then brought it forward with "make oldconfig" on the 
newer source.

That being said, I have a .config that works with 
current releases. I noticed that the overo-defconfig
was removed from arch/arm/configs/ at or around
kernel 3.0.

Any interest in putting it back?

Also, if need be I can setup and test an overo-defconfig
for all the 3.x Stable releases.
 
