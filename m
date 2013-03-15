Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3COSJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:09:03 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64720 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3COSJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:09:01 -0400
Date: Fri, 15 Mar 2013 11:08:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Lokesh Vutla <lokeshvutla@ti.com>
Cc: linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] memory: emif: miscellaneous bug fixes for EMIF driver
Message-ID: <20130315180856.GA30236@kroah.com>
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:35:57AM +0530, Lokesh Vutla wrote:
> This series resolves a few minor issues for EMIF driver.
> 
> Tested all patches on OMAP4430-sdp.
> Patch : "memory: emif: setup LP settings on freq update"
> is tested on a local tree, since freq update cannot be
> tested on mainline.

Can you please resend these with all of the requested changes made, and
acks added?

thanks,

greg k-h
