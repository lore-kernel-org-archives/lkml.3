Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412Ab3BMSUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:20:35 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49390 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934548Ab3BMSUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:20:30 -0500
Date: Wed, 13 Feb 2013 10:20:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Spelvin <linux@horizon.com>
Cc: linux-serial@vger.kernel.org, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org, giometti@linux.it
Subject: Re: [PATCH v2 8/9] pps: Use a single cdev
Message-ID: <20130213182026.GA3996@kroah.com>
References: <cover.1360677367.git.linux@horizon.com>
 <e2550575ba1568393ddd435180bc4d0341d8cae3.1360677367.git.linux@horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2550575ba1568393ddd435180bc4d0341d8cae3.1360677367.git.linux@horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 02:02:42AM -0500, George Spelvin wrote:
> One per device just seems wasteful, when we already manintain a
> data structure to map minor numbers to devices, and we already have
> a PPS_MAX_SOURCES #define.
> 
> This is also a more comprehensive fix to the use-after-free bug
> that has already received a minimal patch.
> ---
>  drivers/pps/pps.c          | 66 ++++++++++++++++++++++++----------------------
>  include/linux/pps_kernel.h |  1 -
>  2 files changed, 34 insertions(+), 33 deletions(-)

You forgot a Signed-off-by: line for this patch, so I can't apply it, or
the 9/9 patch :(

Care to resend just these two after fixing this up?

thanks,

greg k-h
