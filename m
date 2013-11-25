Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab3KYTnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:43:02 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55410 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3KYTm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:42:59 -0500
Date: Mon, 25 Nov 2013 20:42:56 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jan Kara <jack@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: ARM: nommu: Boot hang after VFS: Mounted root (ext2 filesystem)
 on device 1:0.
Message-ID: <20131125194256.GC28642@pengutronix.de>
References: <1385393160.4753.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385393160.4753.4.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 25, 2013 at 11:26:00PM +0800, Axel Lin wrote:
> I got hangup at boot after "VFS: Mounted root (ext2 filesystem) on device 1:0.".
> I'm using ext2 initrd as root.
which mainline version are you using? I don't know your problem, and I'm
not using ext2 on my nommu target. So the only thing I can offer you is
testing the same version.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
