Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab3GaMwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 08:52:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3GaMwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 08:52:36 -0400
Date: Wed, 31 Jul 2013 05:53:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v4 1/5] net/usb/r815x: replace USB buffer from stack to
 DMA-able
Message-ID: <20130731125353.GC30635@kroah.com>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
 <1375262486-5373-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375262486-5373-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:21:22PM +0800, Hayes Wang wrote:
> Some USB buffers use stack which may not be DMA-able.
> Use the buffers from kmalloc to replace those one.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
