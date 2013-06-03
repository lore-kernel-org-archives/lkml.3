Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab3FCRrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:47:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3FCRrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:47:10 -0400
Date: Mon, 3 Jun 2013 10:47:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roger Quadros <rogerq@ti.com>
Cc: stern@rowland.harvard.edu, balbi@ti.com, arnd@arndb.de,
        adrienverge@gmail.com, kishon@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] USB: PHY: Improve PHY selection logic
Message-ID: <20130603174709.GA11059@kroah.com>
References: <1369999743-11758-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369999743-11758-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 02:29:01PM +0300, Roger Quadros wrote:
> Hi,
> 
> Improve Kconfig so that the relevant PHY driver can be explicitely
> selected by the controller driver instead of relying on the user
> to do so.
> 
> Detailed description in patch 1.

Felipe needs to take these, not I.

thanks,

greg k-h
