Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaI2PxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:53:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaI2PxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:53:12 -0400
Date: Mon, 29 Sep 2014 11:52:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: phy: msm: Fix Sparse warning
Message-ID: <20140929155216.GA9351@kroah.com>
References: <1411994860-3429-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411994860-3429-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 06:17:40PM +0530, Pramod Gurav wrote:
> This change fixes below sparse warning:
> drivers/usb/phy/phy-msm-usb.c:1397:30:
> warning: symbol 'msm_otg_mode_fops' was not declared.Should it be static?
> 
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/usb/phy/phy-msm-usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This is already in my tree, why resend it?

confused,

greg k-h
