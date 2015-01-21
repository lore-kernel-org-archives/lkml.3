Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbbAUPEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:04:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35357 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754121AbbAUPD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:03:57 -0500
Date: Wed, 21 Jan 2015 10:03:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: arun.ramamurthy@broadcom.com
cc: linux@prisktech.co.nz, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sbranden@broadcom.com>,
        <rjui@broadcom.com>, Arun Ramamurthy <arunrama@broadcom.com>
Subject: Re: [PATCHv3 1/2] usb: ehci-platform: add support for multiple phys
 per controller
In-Reply-To: <1421712330-11089-2-git-send-email-arun.ramamurthy@broadcom.com>
Message-ID: <Pine.LNX.4.44L0.1501211002380.1670-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015 arun.ramamurthy@broadcom.com wrote:

> From: Arun Ramamurthy <arunrama@broadcom.com>
> 
> Added support for cases where one controller is connected
> to multiple phys.
> 
> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
> Reviewed-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Scott Branden <sbranden@broadcom.com>
> Tested-by: Scott Branden <sbranden@broadcom.com>
> ---

Right here is where you should explain how v3 of this patch is 
different from v2.

Anyway, it looks good.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Did you run it through checkpatch.pl?

Alan Stern

