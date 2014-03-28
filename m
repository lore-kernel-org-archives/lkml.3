Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaC1OLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 10:11:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48801 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaC1OLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 10:11:15 -0400
Date: Fri, 28 Mar 2014 17:11:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Neil Armstrong <superna9999@gmail.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Archana kumari <archanakumari959@gmail.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Staging: netlogic: long lines in xlr_net.c
Message-ID: <20140328141105.GI6991@mwanda>
References: <53357C65.8050400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53357C65.8050400@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 02:43:01PM +0100, Neil Armstrong wrote:
> checkpatch script returns the following warning:
> WARNING: line over 80 characters
> 310: FILE: drivers/staging/netlogic/xlr_net.c:310:
> +               void *accel_priv, select_queue_fallback_t fallback)
> 
> This patch fixes the coding style issue.
> 
> Signed-off-by: Neil Armstrong <superna9999@gmail.com>

Heh.  Looks ok this time but it doesn't apply to linux-next.  Someone
already sent this patch.  Sorry about that.

regards,
dan carpenter

