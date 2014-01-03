Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaACHzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 02:55:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17282 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaACHzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 02:55:06 -0500
Date: Fri, 3 Jan 2014 10:55:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tim Jester-Pfadt <t.jp@gmx.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH v3] Staging: rtl8188eu: Fixed coding style issues
Message-ID: <20140103075503.GC30234@mwanda>
References: <20140102204640.GA1149@archlinux>
 <20140102232259.GA4112@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140102232259.GA4112@archlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 12:22:59AM +0100, Tim Jester-Pfadt wrote:
> Fixed indentation coding style issues on rtw_io.c
> 
> Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
> ---
Next time, if you do a v2 patch please put a note here under the ---
line what changed between the previous one and this one.

2:  changed blah blah blah.

>  drivers/staging/rtl8188eu/core/rtw_io.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)


regards,
dan carpenter

