Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3FFGGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 02:06:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35390 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3FFGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 02:06:44 -0400
Date: Thu, 6 Jun 2013 09:06:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Aldo Iljazi <neonsync1@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: anrdroid: sync.c: fixed all checkpatch warnings
Message-ID: <20130606060628.GZ28112@mwanda>
References: <1370465159-8609-1-git-send-email-neonsync1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370465159-8609-1-git-send-email-neonsync1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 11:45:59PM +0300, Aldo Iljazi wrote:
> Specifically fixed: 
> sync.c:128: WARNING: braces {} are not necessary for single statement blocks
> sync.c:879: WARNING: Prefer seq_puts to seq_printf
> sync.c:883: WARNING: Prefer seq_puts to seq_printf
> sync.c:898: WARNING: Prefer seq_puts to seq_printf
> sync.c:902: WARNING: Prefer seq_puts to seq_printf
> sync.c:943: WARNING: Prefer seq_puts to seq_printf
> sync.c:952: WARNING: Prefer seq_puts to seq_printf
> sync.c:956: WARNING: Prefer seq_puts to seq_printf
> sync.c:964: WARNING: Prefer seq_puts to seq_printf
> total: 9 warnings,
> 

This breaks the build and it doesn't apply to linux-next.  Please
be more careful in the future.

regards,
dan carpenter

