Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaEPJFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:05:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24365 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaEPJFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:05:01 -0400
Date: Fri, 16 May 2014 12:03:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: rupesh.gujare@atmel.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ozwpan: remove redundant NULL check for devs
Message-ID: <20140516090332.GB16255@mwanda>
References: <20140516080810.GA16229@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516080810.GA16229@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 05:08:10PM +0900, Daeseok Youn wrote:
> >From 1cebea7a40490d0d0b122eb444a105d424af42e6 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Fri, 16 May 2014 17:02:04 +0900
> Subject: [PATCH] staging: ozwpan: remove redundant NULL check for devs
> 

Your patches before were fine.  Why do you have these lines in them now?
Please resend.

Otherwise this looks fine.

regards,
dan carpenter


