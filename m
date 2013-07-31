Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab3GaMxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 08:53:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3GaMxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 08:53:36 -0400
Date: Wed, 31 Jul 2013 05:54:53 -0700
From: Greg KH <greg@kroah.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v4 4/5] net/usb/r8152: make sure the USB buffer is
 DMA-able
Message-ID: <20130731125453.GD30635@kroah.com>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
 <1375262486-5373-1-git-send-email-hayeswang@realtek.com>
 <1375262486-5373-4-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375262486-5373-4-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:21:25PM +0800, Hayes Wang wrote:
> Allocate the required memory before calling usb_control_msg. And
> the additional memory copy is necessary.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
