Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaFBMT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:19:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26820 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFBMT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:19:58 -0400
Date: Mon, 2 Jun 2014 15:19:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: John Church <sleeveroller@gmail.com>
Cc: gregkh@linuxfoundation.org, lisa@xenapiadmin.com, bergwolf@gmail.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        doug.s.oucharek@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix sparse warnings for undeclared
 symbols
Message-ID: <20140602121918.GZ15585@mwanda>
References: <1401710628-3690-1-git-send-email-sleeveroller@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401710628-3690-1-git-send-email-sleeveroller@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 01:03:48PM +0100, John Church wrote:
> This patch fixes the following sparse warnings for drivers/staging/lustre/lnet/lnet/router.c:
> 
> router.c:139:1: warning: symbol 'lnet_ni_notify_locked' was not declared. Should it be static?
> router.c:277:1: warning: symbol 'lnet_add_route_to_rnet' was not declared. Should it be static?
> 

Why not just make them static?  They don't seem to be used outside of
that file.  What am I missing?

regards,
dan carpenter

