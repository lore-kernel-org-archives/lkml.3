Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaJJJ4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:56:51 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:47804 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaJJJ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:56:49 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 10 Oct 2014 11:54:00 +0200
From: Johan Hovold <johan@kernel.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: serial: ftdi_sio: add Awinda Station and Dongle
 products
Message-ID: <20141010095400.GE12494@localhost>
References: <1412930694-28769-1-git-send-email-frans.klaver@xsens.com>
 <1412934728-23475-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412934728-23475-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:52:08AM +0200, Frans Klaver wrote:
> Add new IDs for the Xsens Awinda Station and Awinda Dongle.
> 
> While at it, order the definitions by PID and add a logical separation
> between devices using Xsens' VID and those using FTDI's VID.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
> Third time's a charm.

Thanks for your persistence. :)

I'll queue it up when rc1 is out.

Thanks,
Johan
