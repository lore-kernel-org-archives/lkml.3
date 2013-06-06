Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3FFSB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:01:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3FFSB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:01:27 -0400
Date: Thu, 6 Jun 2013 11:01:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
Message-ID: <20130606180125.GA26084@kroah.com>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
 <1370453866-16534-11-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370453866-16534-11-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 06:37:03PM +0100, Nick Dyer wrote:
> Atmel maXTouch chips can be addressed via an "Object Based Protocol" which
> defines how i2c registers are mapped to different functions within the
> chips. This interface exposes the register map and allows user-space
> utilities to inspect and alter object configuration, and to view diagnostic
> data, while the device is running.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> Acked-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   82 ++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)

Whenever you add/remove/modify sysfs files, you also need a
Documentation/ABI/ update as well.  Please include that.

thanks,

greg k-h
