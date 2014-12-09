Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaLIA3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:29:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62155 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaLIA3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:29:15 -0500
Date: Mon, 8 Dec 2014 16:29:11 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: George McCollister <george.mccollister@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: add nt124 usb to serial driver
Message-ID: <20141209002911.GA3003@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	George McCollister <george.mccollister@gmail.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1418081057-25283-1-git-send-email-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418081057-25283-1-git-send-email-george.mccollister@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George,

On Mon, Dec 08, 2014 at 05:24:17PM -0600, George McCollister wrote:
> This driver is for the NovaTech 124 4x serial expansion board for the
> NovaTech OrionLXm.
> 
> Firmware source code can be found here:
> https://github.com/novatechweb/nt124
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---
>  drivers/usb/serial/Kconfig  |   9 +
>  drivers/usb/serial/Makefile |   1 +
>  drivers/usb/serial/nt124.c  | 429 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 439 insertions(+)
>  create mode 100644 drivers/usb/serial/nt124.c
> 
> diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
[...]

It applies to next without any errors, there are no checkpatch issues
other than recommending updating the MAINTAINERS file, and I can't find
any other obvious problems.  Looks good to me.

Reviewed-by: Jeremiah Mahler <jmmahler@gmail.com>

-- 
- Jeremiah Mahler
