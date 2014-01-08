Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbaAHXq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:46:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbaAHXqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:46:54 -0500
Date: Wed, 8 Jan 2014 15:47:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, Paul Zimmerman <paulz@synopsys.com>,
        josh@joshtriplett.org
Subject: Re: [PATCH] drivers: dwc2: Mark function as static in core.c
Message-ID: <20140108234724.GA13405@kroah.com>
References: <20131221102029.GA3151@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131221102029.GA3151@rashika>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 03:50:29PM +0530, Rashika Kheria wrote:
> Mark function dwc2_set_param_uframe_sched() as static in core.c because
> it is not used outside this file.
> 
> This eliminates the following warning in core.c:
> drivers/staging/dwc2/core.c:2739:5: warning: no previous prototype for ‘dwc2_set_param_uframe_sched’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

This patch doesn't apply to my tree.

And please stop sending patches in base64 mode, it makes it impossible
to add reviewed-by: markings to them.

thanks,

greg k-h
