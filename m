Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaAUUAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:00:05 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64713 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaAUUAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:00:02 -0500
Date: Tue, 21 Jan 2014 11:59:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] USB: input: gtco.c: fix usb_dev leak
Message-ID: <20140121195957.GB29615@core.coreip.homeip.net>
References: <1390087466-9898-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390087466-9898-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 03:24:26AM +0400, Alexey Khoroshilov wrote:
> There is usb_get_dev() in gtco_probe(), but there is no usb_put_dev()
> anywhere in the driver.
> 
> The patch adds usb_get_dev() to failure handling code of gtco_probe()
> and to gtco_disconnect(().

Hmm, I think gtco should simply not use usb_get_dev() in the first
place.

Thanks.

-- 
Dmitry
