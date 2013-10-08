Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3JHNYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:24:06 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:58730 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab3JHNYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:24:01 -0400
Date: Tue, 8 Oct 2013 16:23:59 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Subject: Undoing 'quiet' kernel command line option after boot?
Message-ID: <20131008132359.GX7782@lakka.kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:1bc8:1004::1
X-SA-Exim-Mail-From: mikko.rapeli@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible re-enable more verbose kernel logs/printk's to default
console after boot is done from userspace?

I have a system with correct serial console setting on kernel command line
but there's 'quiet' as well to make the boot faster. After boot I'd like to
run some tests on the platform but would like to get more verbose kernel
messages displayed on the same serial console so they can more reliably be
captured on another PC in case something blows up with trinity etc.

Tried to search /proc and /sys and kernel sources but didn't find anything
related yet.

Thanks,

-Mikko
