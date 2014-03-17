Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaCQXFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:05:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaCQXFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:05:39 -0400
Date: Mon, 17 Mar 2014 16:07:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Chan <benchan@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Greg Suarez <gsuarez@smithmicro.com>
Subject: Re: [PATCH 1/2] USB: cdc: add MBIM extended functional descriptor
 structure
Message-ID: <20140317230740.GA32440@kroah.com>
References: <1394952550-9308-1-git-send-email-benchan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394952550-9308-1-git-send-email-benchan@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 11:49:09PM -0700, Ben Chan wrote:
> This patch adds the MBIM extended functional descriptor structure
> defined in "Universal Serial Bus Communications Class Subclass
> Specification for Mobile Broadband Interface Model, Revision 1.0,
> Errata-1" published by USB-IF.
> 
> Signed-off-by: Ben Chan <benchan@chromium.org>
> ---
>  include/uapi/linux/usb/cdc.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
