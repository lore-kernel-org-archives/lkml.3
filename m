Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbbASPOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:14:02 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:37825 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbbASPN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:13:59 -0500
Date: Mon, 19 Jan 2015 16:14:08 +0100
From: Johan Hovold <johan@kernel.org>
To: Mark Glover <mark@actisense.com>
Cc: johan@kernel.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added PIDs for Actisense USB Devices
Message-ID: <20150119151408.GT30960@localhost>
References: <1421310874-6754-1-git-send-email-mark@actisense.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421310874-6754-1-git-send-email-mark@actisense.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 08:34:34AM +0000, Mark Glover wrote:
> From: Mark Glover <mark@actisense.com>
> 
> Signed-off-by: Mark Glover <mark@actisense.com>

Thanks for the patch and for addressing Peter's comments.

A couple of minor nits: Please use a subsystem prefix for your patch
summary, for example:

	"USB: ftdi_sio: add PIDs for Actisense devices"

You should also include a commit message (e.g. your current subject)
even if this is a simple patch.

You are adding both Actisense and Chetco product ids. How are these
related? Shouldn't the Chetco be under it's own heading (and be
mentioned in the commit log)?

And when resending, please include a "PATCH v4" prefix to make it easy
to track patch revisions.

Thanks,
Johan
