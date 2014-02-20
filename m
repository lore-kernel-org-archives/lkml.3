Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaBTRox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:44:53 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59334 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752982AbaBTRov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:44:51 -0500
Message-ID: <53063F09.9000102@free-electrons.com>
Date: Thu, 20 Feb 2014 18:44:41 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: How to get rid of IRQF_DISABLED for good?
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In spite of the patches I have been sending (and resending!) over the
past months, there are still 118 occurrences of the idle IRQF_DISABLED
flag in the kernel code. This corresponds to 31 patches which haven't
been accepted yet.

What would you advise to get rid of IRQF_DISABLED for good?

  * Send a treewide patch removing the last occurrences in one shot,
    bypassing the regular maintainers? Who could take it?
  * Remove the definition of IRQF_DISABLED to force the individual
    maintainers (and out of tree drivers!) to update their code? It
    could be a way of seeing which code isn't maintained any more ;)
  * Continue to resend the patches for a few more cycles, until the
    corresponding maintainers can no longer bear the discredit?
  * Any other solution?

Thank you in advance for your advise!

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

