Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3LKIh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 03:37:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42098 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3LKIhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 03:37:53 -0500
Date: Wed, 11 Dec 2013 11:33:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Steven Luo <steven@steven676.net>, devel@driverdev.osuosl.org,
        fabs@goesec.de, tony@atomide.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        pavel@ucw.cz, pali.rohar@gmail.com, nico@ngolde.de
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing
 instead of remap_pfn_range
Message-ID: <20131211083359.GU28413@mwanda>
References: <1386014416-4556-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20131207234912.GA1245@steven676.net>
 <52A81830.3000305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A81830.3000305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 09:45:52AM +0200, Ivajlo Dimitrov wrote:
> I can pick your changes and re-send the original patch with them
> incorporated if there are no objections. Are you fine with that?
> 

Do it on top of staging-next, don't redo the original.

regards,
dan carpenter
