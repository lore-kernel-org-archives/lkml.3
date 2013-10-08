Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3JHNpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:45:42 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:49797 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3JHNpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:45:41 -0400
Date: Tue, 8 Oct 2013 16:45:40 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: Undoing 'quiet' kernel command line option after boot?
Message-ID: <20131008134540.GY7782@lakka.kapsi.fi>
References: <20131008132359.GX7782@lakka.kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008132359.GX7782@lakka.kapsi.fi>
X-SA-Exim-Connect-IP: 2001:1bc8:1004::1
X-SA-Exim-Mail-From: mikko.rapeli@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 04:23:59PM +0300, Mikko Rapeli wrote:
> Is it possible re-enable more verbose kernel logs/printk's to default
> console after boot is done from userspace?

Ah, oops messages are printed to serial console also in 'quiet' mode.

Didn't took long to find out with trinity.

-Mikko
