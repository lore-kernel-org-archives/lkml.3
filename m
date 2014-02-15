Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaBOTPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:15:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaBOTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:15:24 -0500
Date: Sat, 15 Feb 2014 11:16:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-kernel@vger.kernel.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com
Subject: Re: [PATCHv3 6/6] mailbox: move the internal definitions into a
 private file
Message-ID: <20140215191645.GF1801@kroah.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
 <1392488822-18178-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392488822-18178-1-git-send-email-jaswinder.singh@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 11:57:02PM +0530, Jassi Brar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> This is needed for extracting the omap_mbox. The OMAP mailbox
> code has a need for exporting some pre-existing API to not
> break the current clients.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
>  drivers/mailbox/mailbox.c          | 62 +-----------------------------
>  drivers/mailbox/mailbox_internal.h | 77 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 78 insertions(+), 61 deletions(-)
>  create mode 100644 drivers/mailbox/mailbox_internal.h

Also, this patch doesn't seem to be needed at all here, nothing breaks
without it, so why include it in this series?

thanks,

greg k-h
