Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaA0WtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:49:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaA0WtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:49:00 -0500
Date: Mon, 27 Jan 2014 14:50:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: xypron.glpk@gmx.de
Cc: devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        ly80toro@cip.cs.fau.de, linux-kernel@vger.kernel.org,
        ke42caxa@cip.cs.fau.de
Subject: Re: [PATCH 1/1] usbip/userspace/libsrc/names.c: memory leak
Message-ID: <20140127225004.GA17970@kroah.com>
References: <1390861789-8981-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390861789-8981-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 11:29:48PM +0100, xypron.glpk@gmx.de wrote:
> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> 
> p is freed if NULL.

Not a real problem, right?

> p is leaked if second calloc fails.

You just created a new bug in your "fix" :(

Please run your patches through scripts/checkpatch.pl, odds are, it
would have caught this error.

greg k-h
