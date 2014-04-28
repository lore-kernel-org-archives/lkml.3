Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbaD1TZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:25:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33302 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbaD1TZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:25:35 -0400
Date: Mon, 28 Apr 2014 22:24:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        rashika.kheria@gmail.com, linux-kernel@vger.kernel.org,
        tulinizer@gmail.com, michael.banken@mathe.stud.uni-erlangen.de,
        andriy.shevchenko@linux.intel.com, lorenz@badgers.com
Subject: Re: [PATCH v2] staging: silicom: Remove unused pointer in
 bypass_init_module()
Message-ID: <20140428192455.GW26890@mwanda>
References: <20140428204727.699dc618@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428204727.699dc618@spike>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 08:47:27PM +0200, Christian Engelmayer wrote:
> Pointer 'pbpctl_dev_c' in function bypass_init_module() is unused. Thus remove
> it. With the last variable declaration gone, there is no more need for an own
> block. Remove it and adapt the indenting accordingly.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> v2: Added changes requested by Dan Carpenter:
> 
>     Dan pointed out that with the declaration gone, the indent block shall be
>     removed. This was intentionally left out in v1 in order to keep the
>     changeset more readable. However, according to the input, also with the
>     additional indenting change this still qualifies for one logical change.
> 
> Compile tested and applies against v3.15-rc2 as well as branch staging-next
> of tree git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

Great thanks.  :)  You only need to work against staging next and not
v3.15-rc2 because this will go into v3.16.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

