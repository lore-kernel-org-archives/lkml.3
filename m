Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbaGWXzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:55:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbaGWXzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:55:45 -0400
Date: Wed, 23 Jul 2014 16:55:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Enric Balletbo i Serra <eballetbo@iseebcn.com>
Cc: pavan_savoy@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] drivers/misc/ti-st: Load firmware from ti-connectivity
 directory.
Message-ID: <20140723235545.GA976@kroah.com>
References: <1406027318-26186-1-git-send-email-eballetbo@iseebcn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406027318-26186-1-git-send-email-eballetbo@iseebcn.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:08:38PM +0200, Enric Balletbo i Serra wrote:
> Looks like the default location for TI firmware is inside the ti-connectivity
> directory, to be coherent with other firmware request used by TI drivers, load
> the TIInit firmware from this directory instead of /lib/firmware directly.

Ah, it's this way in the linux-firmware package, I'll go queue this up
now, sorry for the delay.

greg k-h
