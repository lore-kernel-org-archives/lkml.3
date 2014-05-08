Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaEHLsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:48:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20306 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaEHLsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:48:32 -0400
Date: Thu, 8 May 2014 14:48:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH] staging: winbond: use dev_err() instead of printk()
Message-ID: <20140508114805.GG26890@mwanda>
References: <1399549113-19758-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399549113-19758-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 01:38:33PM +0200, Martin Kepplinger wrote:
> For obvious error messages, use dev_err() in order to provide userspace
> with more useful information and use the common kernel coding style.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> this applies to v3.15-rc4
> 

Do these kinds of patches against linux-next.  This patch applies fine
so it's not a worry.

regards,
dan carpenter

