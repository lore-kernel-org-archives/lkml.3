Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaKKJx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:53:26 -0500
Received: from smtpout3.wanadoo.co.uk ([80.12.242.59]:17406 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaKKJxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:53:25 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2014 04:53:24 EST
X-ME-Helo: bother.homenet
X-ME-Date: Tue, 11 Nov 2014 10:45:51 +0100
X-ME-IP: 95.146.110.34
Date: Tue, 11 Nov 2014 09:45:50 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: intel drm regression with linux-3.18-rc4 kernel
Message-ID: <20141111094550.0765545e@bother.homenet>
X-Mailer: Claws Mail 3.10.0 (GTK+ 2.24.25; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There seems to be a regression with linux-3.18-rc4 using drm with i915
graphics on one of my machines, a crappy netbook which uses a Intel
Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated
Graphics Controller (rev 03) graphics controller, when using
gnome-shell.  The first time I bring up X, direct rendering seems to
fail and at a guess the system falls back to software (llvm-pipe)
rendering - in any event, it is very slow (around 4 or 5 frames/sec
instead of 60 frames/sec).  If I log out and log in again drm works
fine thereafter, with normal frame rates.

This regression occurred somewhere between the 3.17 and 3.18-rc4
kernels.

Chris
