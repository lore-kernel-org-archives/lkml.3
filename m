Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaDAGez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:34:55 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35416 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaDAGey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:34:54 -0400
Date: Tue, 1 Apr 2014 08:34:44 +0200
From: Anders Darander <anders.darander@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: ft1000-usb: fixed a few code style issues
Message-ID: <20140401063444.GA10337@gmail.com>
References: <1396247188-6513-1-git-send-email-anders.darander@gmail.com>
 <20140331225549.GA27227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331225549.GA27227@kroah.com>
X-Accept-Language: sv, en, de
X-GPG-Fingerprint: 5AF0 B2E9 78FE 9D75 D110  6F8F 3E31 84D7 920E 938C
X-GPG-Key-Id: 0x920E938C
X-GPG-Keyserver: hkp://keys.gnupg.net
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@linuxfoundation.org> [140401 00:53]:

> On Mon, Mar 31, 2014 at 08:26:28AM +0200, Anders Darander wrote:
> > Fixed a few code style issues, particularly:

> > Add do {} while (0) wrapper around seq_* macros.
> > Change printk(KERN_WARN...) to netdev_warn(...).

> That's 2 different things, please split this up into 2 different
> patches.

Split up patches on their way.

> Remember, one patch does one thing.

Sure.

In this case I deemed them to be small and though not the same, but
still mosly coding style issues. Though, I can certainly see that the
printk to netdev_warn actually adds more than just a coding style
clean-up.

Cheers,
Anders

