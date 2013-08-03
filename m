Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3HCDUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 23:20:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3HCDUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 23:20:13 -0400
Date: Sat, 3 Aug 2013 11:10:49 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, dan.carpenter@oracle.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ozwpan: Fix farewell report.
Message-ID: <20130803031049.GA2999@kroah.com>
References: <51FB915C.1050003@atmel.com>
 <1375441456-20415-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375441456-20415-1-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 12:04:16PM +0100, Rupesh Gujare wrote:
> This patch fixes issues reported by Dan here:-
> http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2013-August/040052.html

Please list the issues in the patch changelog itself, as sometimes you
don't have web access, and I sure wouldn't rely on that email archive to
always be around (hint, it's been down a bunch recently...)

Can you please resend this with a better changelog description?

thanks,

greg k-h
