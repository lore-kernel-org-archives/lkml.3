Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab3CLQCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:02:53 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:35113 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932390Ab3CLQCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:02:52 -0400
Date: Tue, 12 Mar 2013 17:02:49 +0100
From: felix-linuxkernel@fefe.de
To: linux-kernel@vger.kernel.org
Subject: Who is responsible for radeon driver bugs?
Message-ID: <20130312160249.GA32182@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The radeon driver does not work on my laptop.
I sent a bug report here a week ago, but got no responses.
What is the right place to send bug reports for the radeon driver?

The bug is that LVDS output does not work.  This is, according to lspci,
a 5000M series Madison Radeon.

When I insmod the module, the screen stays in text mode and appears
locked up.

If something is connected to the HDMI port, I get a framebuffer console
there.  LVDS stays in broken text mode though.

When I start X, the HDMI screen turns dark and stays dark and the LVDS
screen also stays dark and I have to reboot.

The driver loads the REDWOOD firmware OK.

Who is responsible for this?  Where do I send my bug report?

Thanks,

Felix
