Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaESLAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:00:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38084 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaESLAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:00:05 -0400
Date: Mon, 19 May 2014 13:59:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, pavel@ucw.cz, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] staging: winbond: use dev_err() instead of
 printk()
Message-ID: <20140519105943.GQ16255@mwanda>
References: <20140509082131.GA21616@Nokia-N900>
 <1400496911-11658-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400496911-11658-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:55:11PM +0200, Martin Kepplinger wrote:
> For obvious error messages, use dev_err() in order to provide userspace
> with more useful information and use the common kernel coding style.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> i just waited a week or so. this applies to next-20140516.

A week is too short a time.  You will always get a message that your
patch was either applied or dropped.

> 
> greetings from Linuxdays Vienna, Austria

Hi hi.  Greetings from Africa.  :)

regards,
dan carpenter

