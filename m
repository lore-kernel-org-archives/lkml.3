Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBRUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:09:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaBRUJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:09:58 -0500
Date: Tue, 18 Feb 2014 12:11:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] usb: phy: twl4030-usb: Silence checkpatch warnings
Message-ID: <20140218201123.GA21119@kroah.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
 <1392627565-1829-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392627565-1829-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:29:18PM +0530, Kishon Vijay Abraham I wrote:
> From: Sachin Kamat <sachin.kamat@linaro.org>
> 
> Silences the following warnings:
> WARNING: sizeof *twl should be sizeof(*twl)
> WARNING: sizeof *otg should be sizeof(*otg)
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/phy-twl4030-usb.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

This isn't a 3.14-final worthy patch, sorry.
