Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3CCJXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:23:09 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:51522 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3CCJXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:23:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Initialize cs_gpio and cs_gpios with -ENOENT
To: Andreas Larsson <andreas@gaisler.com>
Cc: spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <1360761625-15562-1-git-send-email-andreas@gaisler.com>
References: <1360761625-15562-1-git-send-email-andreas@gaisler.com>
Date: Sat, 02 Mar 2013 22:46:47 +0000
Message-Id: <20130302224647.7D72C3E2F21@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013 14:20:25 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> The return value from of_get_named_gpio is -ENOENT when the given index
> matches a hole in the "cs-gpios" property phandle list. However, the
> default value of cs_gpio in struct spi_device and entries of cs_gpios in
> struct spi_master is -EINVAL, which is documented to indicate that a
> GPIO line should not be used for the given spi_device.
> 
> This sets the default value of cs_gpio in struct spi_device and entries
> of cs_gpios in struct spi_master to -ENOENT. Thus, -ENOENT is the only
> value used to indicate that no GPIO line should be used.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Applied, thanks.
g.

