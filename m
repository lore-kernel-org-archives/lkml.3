Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab3JPHEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:04:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45704 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3JPHEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:04:23 -0400
Date: Wed, 16 Oct 2013 10:03:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Archana kumari <archanakumari959@gmail.com>,
        devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] staging: media: Fix build for iMON LIRC driver
Message-ID: <20131016070340.GC11731@mwanda>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com>
 <1381845763-10487-3-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381845763-10487-3-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 04:02:43PM +0200, Thierry Reding wrote:
> Add a missing , between parameters in a call to dev_info().
> 

Greg already reverted the original patch.

The original patch wasn't sent to the list.  Archana, use
scripts/get_maintainer.pl to find out who to send patches to.  Don't
CC the linux-kernel list though because they don't care about details in
staging.

regards,
dan carpenter

