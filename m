Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaFAAIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 20:08:24 -0400
Received: from foo.stuge.se ([212.116.89.98]:53323 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815AbaFAAIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 20:08:23 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 May 2014 20:08:23 EDT
Message-ID: <20140601000059.27360.qmail@stuge.se>
Date: Sun, 1 Jun 2014 02:00:59 +0200
From: Peter Stuge <peter@stuge.se>
To: Philipp Hachtmann <hachti@hachti.de>
Cc: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb/ftdi_sio: Add support for setting CBUS pins on
	FT232H
Mail-Followup-To: Philipp Hachtmann <hachti@hachti.de>, jhovold@gmail.com,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1401579066-8298-1-git-send-email-hachti@hachti.de> <1401579066-8298-3-git-send-email-hachti@hachti.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401579066-8298-3-git-send-email-hachti@hachti.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Hachtmann wrote:
> This patch adds a sysfs attribute "cbus" which allows to set the
> four CBUS pins on the FT232H.

I think this should be implemented with the gpio subsystem instead.


//Peter
