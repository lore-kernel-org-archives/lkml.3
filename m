Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3HWNIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:08:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21511 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab3HWNIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:08:20 -0400
Date: Fri, 23 Aug 2013 16:08:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navinp@cdac.in>
Cc: gregkh@linuxfoundation.org, maxtram95@gmail.com, viro@zeniv.linux.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8187se: Remove pt_regs * irq handler
 parameter
Message-ID: <20130823130807.GD4713@mwanda>
References: <1377262442-20111-1-git-send-email-navinp@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377262442-20111-1-git-send-email-navinp@cdac.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 06:24:02PM +0530, navin patidar wrote:
> struct pt_regs pointer is no longer passed as a irq handler
> argument.
> 
> v2:
> remove rtl8180_interrupt cast to (void *) .
> 
> Signed-off-by: navin patidar <navinp@cdac.in>

Great.  Thanks.

regards,
dan carpenter

