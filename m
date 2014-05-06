Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484AbaEFIhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:37:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21275 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934344AbaEFIhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:37:32 -0400
Date: Tue, 6 May 2014 11:37:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] staging: vt6656: make spin_lock_irq() human
 readable
Message-ID: <20140506083709.GS26890@mwanda>
References: <1398877278-2280-1-git-send-email-martink@posteo.de>
 <1399355919-26684-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399355919-26684-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 07:58:39AM +0200, Martin Kepplinger wrote:
> Don't require FIRMWAREbDownload() to, first off, unlock a held lock.
> Thus do all locking in main_usb.c and hold it for a insignificantly
> shorter period of time. This makes the affected area significantly more
> readable though.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

