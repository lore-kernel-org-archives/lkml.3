Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbbAPPV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:21:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbAPPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:21:55 -0500
Date: Fri, 16 Jan 2015 07:21:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hung <hpeter@gmail.com>
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom_tsai@fintek.com.tw, peter_hong@fintek.com.tw
Subject: Re: [PATCH 1/1] serial: Fintek F81232 driver improvement
Message-ID: <20150116152153.GC11240@kroah.com>
References: <1421390481-2871-1-git-send-email-hpeter+linux_kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421390481-2871-1-git-send-email-hpeter+linux_kernel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 02:41:21PM +0800, Peter Hung wrote:
> From: Peter Hong <hpeter@gmail.com>
> 
> The original driver completed with TX function, but RX/MSR/MCR/LSR is not
> workable with this driver. So we rewrite it to make this device workable.
> 
> This patch is tested with PassMark BurnInTest with Cycle-to-115200 +
> MCR/MSR check for 15mins & checked with Suspend-To-RAM/DISK
> 
> Signed-off-by: Peter Hong <hpeter@gmail.com>
> ---
>  drivers/usb/serial/f81232.c | 528 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 440 insertions(+), 88 deletions(-)

Please use get_maintainer.pl to determine who to send this to (hint,
it's not me...)

thanks,

greg k-h
