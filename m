Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3COSN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:13:56 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43642 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3COSNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:13:54 -0400
Date: Fri, 15 Mar 2013 11:13:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 8/8] drivers: misc: use module_platform_driver_probe()
Message-ID: <20130315181351.GA16747@kroah.com>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
 <1363280978-24051-9-git-send-email-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363280978-24051-9-git-send-email-fabio.porcedda@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 06:09:38PM +0100, Fabio Porcedda wrote:
> This patch converts the drivers to use the
> module_platform_driver_probe() macro which makes the code smaller and
> a bit simpler.

Someone else beat you to this fix for these files, sorry.

greg k-h
